---
date: 2024-12-19
researcher: Tech Scout Agent
topic: Finance OS Technical Architecture Patterns
tags: [research, technical, finance-os, architecture, patterns]
status: complete
---

# Technical Research: Finance OS Architecture Patterns

## Executive Summary

This research investigates technical implementation patterns for a Finance OS platform focusing on high-volume reconciliation and workflow automation. The analysis covers four critical areas: transaction matching engines, workflow automation frameworks, frontend performance optimization for large data grids, and state management for complex multi-step wizards.

**Key Findings:**
- **Transaction Matching**: Rule-based engines with fuzzy matching algorithms (Levenshtein, Jaro-Winkler) are standard; Redis/PostgreSQL for indexing; event-driven architecture for real-time processing
- **Workflow Automation**: Temporal.io leads for agentic workflows with durable execution; Camunda for BPMN-based processes; Custom DAGs (Airflow-style) for complex dependencies
- **Data Grids**: TanStack Virtual (formerly react-virtual) is modern standard; Web Workers for heavy computation; Virtual scrolling essential for 10k+ rows
- **Wizard State**: XState for complex state machines; Zustand/Redux for simpler cases; React Hook Form for form state; Progress tracking via URL params or state

---

## 1. Real-Time Transaction Matching Engines

### Problem Domain
High-volume transaction reconciliation requires matching transactions from multiple sources (banks, ERPs, payment processors) with high accuracy and low latency. Typical volumes: 100k-10M+ transactions/day.

### Technical Approaches

#### A. Matching Algorithm Patterns

**1. Exact Matching**
- **Pattern**: Hash-based exact match on key fields (amount, date, reference number)
- **Use Case**: First-pass matching for high-confidence pairs
- **Performance**: O(n) with hash tables, sub-millisecond per transaction
- **Implementation**: 
  ```python
  # Pseudocode
  exact_matches = {}
  for tx in transactions:
      key = hash(tx.amount, tx.date, tx.reference)
      if key in exact_matches:
          match(tx, exact_matches[key])
      else:
          exact_matches[key] = tx
  ```

**2. Fuzzy Matching**
- **Algorithms**: 
  - **Levenshtein Distance**: String similarity (reference numbers, descriptions)
  - **Jaro-Winkler**: Better for names/descriptions with common prefixes
  - **Token-based**: Split strings into tokens, compare token sets
- **Use Case**: Matching when reference numbers have typos or formatting differences
- **Performance**: O(n²) for naive, O(n log n) with indexing
- **Libraries**:
  - Python: `python-Levenshtein`, `fuzzywuzzy`, `rapidfuzz`
  - JavaScript: `fuse.js`, `string-similarity`, `fast-levenshtein`

**3. Rule-Based Matching**
- **Pattern**: Configurable rules engine (e.g., Drools, custom DSL)
- **Rules Examples**:
  - Match if amount within ±0.01% and date within ±2 days
  - Match if description contains keywords AND amount matches
  - Match if multiple fields satisfy weighted criteria
- **Use Case**: Business-specific matching logic
- **State Model**: `pending`, `matched`, `unmatched`, `review_required`

#### B. Architecture Patterns

**1. Event-Driven Matching**
- **Pattern**: Kafka/RabbitMQ for transaction ingestion → Matching service → Results stream
- **Benefits**: Real-time processing, horizontal scaling, fault tolerance
- **Components**:
  - **Ingestion**: Event stream from sources
  - **Matching Service**: Stateless workers consuming events
  - **Results Store**: PostgreSQL/MongoDB for matched pairs
  - **Notification**: WebSocket/SSE for UI updates

**2. Batch Matching with Incremental Updates**
- **Pattern**: Scheduled batch jobs (hourly/daily) + real-time incremental matching
- **Use Case**: High-volume reconciliation where sub-second latency isn't critical
- **Implementation**: 
  - Batch: Full reconciliation run overnight
  - Incremental: Match new transactions as they arrive
  - Merge: Combine batch and incremental results

**3. Indexed Matching**
- **Pattern**: Pre-index transactions by matching keys (amount, date ranges, reference patterns)
- **Data Structures**:
  - **Redis**: In-memory hash tables for fast lookups
  - **PostgreSQL**: B-tree indexes on matching fields, GIN indexes for text search
  - **Elasticsearch**: Full-text search for description matching
- **Performance**: Reduces O(n²) to O(n log n) or better

#### C. State Management for Matching

**State Model:**
```typescript
interface TransactionMatch {
  id: string;
  sourceTx: Transaction;
  targetTx: Transaction;
  confidence: number; // 0-100
  status: 'pending' | 'matched' | 'unmatched' | 'review';
  matchRules: string[]; // Which rules matched
  createdAt: Date;
  reviewedBy?: string;
}
```

**State Transitions:**
- `pending` → `matched`: Auto-match above confidence threshold
- `pending` → `review`: Manual review required
- `review` → `matched`/`unmatched`: User decision
- `matched` → `unmatched`: User override

#### D. Recommended Libraries & Frameworks

**Python Stack:**
- **Matching Engine**: Custom with `rapidfuzz` for fuzzy matching
- **Rules Engine**: `durable-rules` or custom DSL
- **Indexing**: Redis for hot data, PostgreSQL for persistence
- **Streaming**: Apache Kafka or AWS Kinesis

**JavaScript/TypeScript Stack:**
- **Matching**: `fuse.js` or `string-similarity` for client-side, server-side with Node.js
- **Streaming**: Kafka.js or AWS SDK for Kinesis
- **Indexing**: Redis (ioredis), PostgreSQL with pg

**Production Examples:**
- **BlackLine**: Custom matching engine with ML-based confidence scoring
- **ReconArt**: Rule-based matching with fuzzy algorithms
- **HighRadius**: AI-powered matching with learning from user corrections

---

## 2. Workflow Automation Engines for Agentic Workflows

### Problem Domain
Finance workflows require durable execution, retry logic, error handling, and state persistence. "Agentic workflows" involve autonomous agents making decisions and executing tasks.

### Technical Approaches

#### A. Temporal.io

**Architecture:**
- **Workflow Definition**: Code-as-workflow (not visual)
- **Execution Model**: Durable execution with event sourcing
- **State Management**: Workflow state persisted automatically
- **Retry**: Built-in exponential backoff, configurable policies
- **Language Support**: TypeScript, Python, Go, Java

**Key Features:**
- **Durable Timers**: Sleep/wait that survives restarts
- **Activity Retries**: Automatic retry with backoff
- **Versioning**: Workflow versioning for safe updates
- **Child Workflows**: Compose workflows
- **Signals & Queries**: External communication with running workflows

**State Model:**
```typescript
interface WorkflowState {
  status: 'running' | 'completed' | 'failed' | 'cancelled';
  currentStep: string;
  data: Record<string, any>;
  retryCount: number;
  error?: Error;
}
```

**Use Cases:**
- Multi-step approval workflows
- Long-running reconciliation processes
- Scheduled batch jobs with dependencies
- Agentic workflows with decision points

**Pros:**
- Excellent for complex, long-running workflows
- Built-in durability and fault tolerance
- Strong TypeScript support
- Good observability

**Cons:**
- Requires Temporal Cloud or self-hosted infrastructure
- Learning curve for workflow patterns
- Less suitable for simple, stateless workflows

**Example Pattern:**
```typescript
// Temporal workflow for reconciliation
export async function reconciliationWorkflow(
  batchId: string
): Promise<ReconciliationResult> {
  // Step 1: Load transactions
  const transactions = await loadTransactions.execute(batchId);
  
  // Step 2: Run matching (with retry)
  const matches = await matchTransactions.execute(transactions, {
    retry: { maximumAttempts: 3 }
  });
  
  // Step 3: Wait for manual review if needed
  if (matches.requiresReview) {
    await workflow.sleep('24h'); // Durable timer
    await waitForReview.execute(matches.reviewItems);
  }
  
  // Step 4: Generate report
  return await generateReport.execute(matches);
}
```

#### B. Camunda

**Architecture:**
- **Workflow Definition**: BPMN 2.0 (visual modeling)
- **Execution Model**: Process engine with database persistence
- **State Management**: Process instances stored in database
- **Retry**: Configurable retry policies per task
- **Language Support**: Java, REST API (language agnostic)

**Key Features:**
- **BPMN Modeling**: Visual workflow designer
- **DMN Decision Tables**: Business rules engine
- **Forms**: User task forms
- **External Tasks**: Long-running external service calls
- **Message Correlation**: Event-driven workflow triggers

**State Model:**
- Process instances with tokens marking execution position
- Task instances for user/automated tasks
- Variables scoped to process/task level

**Use Cases:**
- BPMN-compliant business processes
- Visual workflow modeling preferred
- Integration with existing Camunda infrastructure
- Complex business rules (DMN)

**Pros:**
- Industry-standard BPMN
- Visual modeling tools
- Strong enterprise features
- Good for business-user configurable workflows

**Cons:**
- Java-heavy (though REST API available)
- Less suitable for code-first workflows
- Heavier infrastructure requirements

#### C. Custom DAG Engines (Airflow-style)

**Architecture:**
- **Workflow Definition**: Python DAG definitions (code)
- **Execution Model**: Directed Acyclic Graph execution
- **State Management**: Task state in database (PostgreSQL)
- **Retry**: Per-task retry policies
- **Language Support**: Python primary, operators can call any language

**Key Features:**
- **DAG Definition**: Declarative task dependencies
- **Scheduling**: Cron-based or event-driven
- **Operators**: Pre-built operators for common tasks
- **XComs**: Inter-task data passing
- **Plugins**: Extensible architecture

**Libraries:**
- **Apache Airflow**: Most popular, mature
- **Prefect**: Modern alternative with better DX
- **Dagster**: Data-aware orchestration
- **Temporal** (mentioned above): Can model DAGs but more general

**State Model:**
```python
# Airflow-style DAG
from airflow import DAG
from airflow.operators.python import PythonOperator

dag = DAG('reconciliation_workflow')

load_txs = PythonOperator(
    task_id='load_transactions',
    python_callable=load_transactions,
    dag=dag
)

match_txs = PythonOperator(
    task_id='match_transactions',
    python_callable=match_transactions,
    dag=dag
)

generate_report = PythonOperator(
    task_id='generate_report',
    python_callable=generate_report,
    dag=dag
)

load_txs >> match_txs >> generate_report
```

**Use Cases:**
- Data pipeline orchestration
- ETL workflows
- Scheduled batch jobs with dependencies
- Complex multi-step processes with clear dependencies

**Pros:**
- Flexible, code-based definition
- Rich ecosystem of operators
- Good for data engineering workflows
- Mature and battle-tested

**Cons:**
- Less suitable for long-running workflows (hours/days)
- No built-in durable timers
- Requires infrastructure management

#### D. Comparison Matrix

| Feature | Temporal | Camunda | Custom DAG (Airflow) |
|---------|----------|---------|---------------------|
| **Durability** | Excellent (event sourcing) | Good (DB persistence) | Good (DB persistence) |
| **Retry Logic** | Built-in, configurable | Configurable | Per-task configurable |
| **Long-running** | Excellent (days/weeks) | Good (hours) | Limited (minutes/hours) |
| **Visual Modeling** | No (code-only) | Yes (BPMN) | Limited (code-based) |
| **Type Safety** | Excellent (TypeScript) | Limited (Java) | Limited (Python) |
| **Learning Curve** | Medium | High | Medium |
| **Infrastructure** | Temporal Cloud or self-host | Self-host or Cloud | Self-host or Cloud |
| **Best For** | Agentic workflows, long-running | BPMN processes, visual | Data pipelines, ETL |

#### E. Recommended Approach

**For Finance OS Platform:**

1. **Primary: Temporal.io**
   - Best fit for agentic workflows with decision points
   - Excellent durability for financial processes
   - Strong TypeScript support aligns with modern frontend
   - Handles long-running workflows (approval chains, reviews)

2. **Secondary: Custom DAG (Prefect)**
   - For scheduled batch reconciliation jobs
   - Data pipeline orchestration
   - ETL workflows

3. **Avoid: Camunda**
   - Unless BPMN compliance is required
   - Heavier infrastructure overhead
   - Less suitable for code-first, agentic workflows

**Hybrid Approach:**
- Use Temporal for user-facing workflows (approvals, reviews, agentic decisions)
- Use Prefect/Airflow for scheduled batch jobs and data pipelines
- Integrate via events/APIs

---

## 3. Frontend Performance for Large Data Grids

### Problem Domain
Finance applications require displaying 10k-1M+ rows of transaction data with smooth scrolling, filtering, sorting, and real-time updates.

### Technical Approaches

#### A. Virtual Scrolling Libraries

**1. TanStack Virtual (formerly react-virtual)**
- **Status**: Modern, actively maintained
- **Approach**: Virtual scrolling with dynamic row heights
- **Performance**: Handles 100k+ rows smoothly
- **Features**:
  - Dynamic row heights
  - Horizontal virtualization
  - Smooth scrolling
  - React 18+ concurrent features support

**Implementation Pattern:**
```typescript
import { useVirtualizer } from '@tanstack/react-virtual'

function DataGrid({ rows }) {
  const parentRef = useRef<HTMLDivElement>(null)
  
  const virtualizer = useVirtualizer({
    count: rows.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 50, // Estimated row height
    overscan: 5, // Render 5 extra rows outside viewport
  })

  return (
    <div ref={parentRef} style={{ height: '600px', overflow: 'auto' }}>
      <div style={{ height: `${virtualizer.getTotalSize()}px`, position: 'relative' }}>
        {virtualizer.getVirtualItems().map((virtualRow) => (
          <div
            key={virtualRow.key}
            style={{
              position: 'absolute',
              top: 0,
              left: 0,
              width: '100%',
              height: `${virtualRow.size}px`,
              transform: `translateY(${virtualRow.start}px)`,
            }}
          >
            {rows[virtualRow.index]}
          </div>
        ))}
      </div>
    </div>
  )
}
```

**2. react-window**
- **Status**: Mature, widely used
- **Approach**: Fixed-size virtual scrolling
- **Performance**: Excellent for fixed row heights
- **Limitations**: Less flexible for dynamic heights

**3. react-virtualized**
- **Status**: Legacy (maintainer recommends react-window)
- **Approach**: Comprehensive virtualization suite
- **Note**: Not recommended for new projects

**Comparison:**
- **TanStack Virtual**: Best for modern React apps, dynamic heights
- **react-window**: Best for fixed heights, smaller bundle size
- **react-virtualized**: Legacy, avoid for new projects

#### B. Web Workers for Data Processing

**Use Cases:**
- Heavy filtering/sorting operations
- Data transformation (formatting, calculations)
- Fuzzy matching (client-side)
- CSV/Excel export generation

**Pattern:**
```typescript
// worker.ts
self.onmessage = (e) => {
  const { data, operation, params } = e.data
  
  let result
  switch (operation) {
    case 'filter':
      result = data.filter(item => 
        // Heavy filtering logic
        item.amount > params.minAmount
      )
      break
    case 'sort':
      result = [...data].sort((a, b) => 
        // Heavy sorting logic
        a.date - b.date
      )
      break
  }
  
  self.postMessage({ result })
}

// Component
const worker = new Worker(new URL('./worker.ts', import.meta.url))

function DataGrid({ data }) {
  const [filteredData, setFilteredData] = useState(data)
  
  useEffect(() => {
    worker.postMessage({ 
      data, 
      operation: 'filter', 
      params: { minAmount: 1000 } 
    })
    
    worker.onmessage = (e) => {
      setFilteredData(e.data.result)
    }
  }, [data])
  
  // Render with virtual scrolling
}
```

**Benefits:**
- Keeps UI responsive during heavy operations
- Parallel processing
- Doesn't block main thread

**Trade-offs:**
- Serialization overhead (data must be JSON-serializable)
- Memory duplication (data in main thread + worker)
- Complexity increase

#### C. Pagination vs Virtualization

**Pagination:**
- **Use When**: 
  - Users need to jump to specific pages
  - Server-side filtering/sorting
  - Very large datasets (1M+ rows)
- **Pros**: Lower memory usage, simpler implementation
- **Cons**: Slower navigation, can't see full dataset at once

**Virtualization:**
- **Use When**:
  - Client-side data (or cached server data)
  - Users need to scroll through data
  - Datasets < 1M rows (client-side)
- **Pros**: Smooth scrolling, see full dataset
- **Cons**: Higher memory usage, more complex

**Hybrid Approach:**
- Virtual scrolling with server-side pagination
- Load pages as user scrolls (infinite scroll)
- Cache loaded pages in memory

#### D. Memory Management Patterns

**1. Data Window Sliding**
- Keep only visible rows + buffer in memory
- Unload rows outside buffer
- Reload when scrolling back

**2. Lazy Column Rendering**
- Render only visible columns
- Virtualize horizontally too

**3. Debounced Updates**
- Debounce filter/sort operations
- Cancel in-flight operations when new input arrives

**4. Memoization**
- Memoize row components
- Memoize expensive calculations
- Use `React.memo` for row components

**Example:**
```typescript
const Row = React.memo(({ row, index }) => {
  // Expensive formatting
  const formattedAmount = useMemo(
    () => formatCurrency(row.amount),
    [row.amount]
  )
  
  return <div>{formattedAmount}</div>
})
```

#### E. Real-World Performance Benchmarks

**Target Metrics:**
- **Initial Render**: < 100ms for 10k rows
- **Scroll FPS**: 60 FPS during scrolling
- **Filter/Sort**: < 500ms for 100k rows
- **Memory**: < 100MB for 100k rows in viewport

**Achievable with:**
- TanStack Virtual + Web Workers
- Proper memoization
- Lazy column rendering
- Debounced operations

#### F. Recommended Stack

**Primary:**
- **TanStack Virtual**: Modern, flexible virtual scrolling
- **Web Workers**: For heavy filtering/sorting (if client-side)
- **React Query/SWR**: For server data caching and pagination

**Data Grid Libraries (Built on Virtual Scrolling):**
- **TanStack Table (React Table)**: Most flexible, requires more setup
- **AG Grid**: Feature-rich, commercial license for advanced features
- **Material-UI DataGrid**: Good for MUI projects, limited customization

**For Finance OS:**
- Use **TanStack Table + TanStack Virtual** for maximum flexibility
- Implement custom finance-specific features (matching UI, reconciliation views)
- Use Web Workers for client-side fuzzy matching if needed

---

## 4. State Management for Complex Multi-Step Wizards

### Problem Domain
Finance workflows often involve multi-step wizards (reconciliation setup, workflow configuration, report generation) with complex validation, conditional steps, and progress tracking.

### Technical Approaches

#### A. State Machine Libraries

**1. XState**
- **Status**: Industry standard for state machines
- **Approach**: Declarative state machines with visualizer
- **Features**:
  - Hierarchical states
  - Guards (conditional transitions)
  - Actions (side effects)
  - Services (async operations)
  - Visual state machine editor

**State Model:**
```typescript
import { createMachine, assign } from 'xstate'

const wizardMachine = createMachine({
  id: 'reconciliationWizard',
  initial: 'sourceSelection',
  context: {
    source: null,
    target: null,
    rules: [],
    errors: {},
  },
  states: {
    sourceSelection: {
      on: {
        SELECT_SOURCE: {
          target: 'targetSelection',
          actions: assign({ source: (_, event) => event.source }),
        },
      },
    },
    targetSelection: {
      on: {
        SELECT_TARGET: {
          target: 'rulesConfiguration',
          actions: assign({ target: (_, event) => event.target }),
        },
        BACK: 'sourceSelection',
      },
    },
    rulesConfiguration: {
      on: {
        ADD_RULE: {
          actions: assign({
            rules: (context, event) => [...context.rules, event.rule],
          }),
        },
        NEXT: {
          target: 'review',
          guard: (context) => context.rules.length > 0,
        },
        BACK: 'targetSelection',
      },
    },
    review: {
      on: {
        SUBMIT: 'submitting',
        BACK: 'rulesConfiguration',
      },
    },
    submitting: {
      invoke: {
        src: 'submitReconciliation',
        onDone: 'success',
        onError: {
          target: 'review',
          actions: assign({
            errors: (_, event) => event.data,
          }),
        },
      },
    },
    success: {
      type: 'final',
    },
  },
})

// Usage
const [state, send] = useMachine(wizardMachine)
```

**Pros:**
- Explicit state transitions
- Visual debugging
- Handles complex flows well
- Type-safe with TypeScript

**Cons:**
- Learning curve
- Can be overkill for simple wizards
- More boilerplate

**2. Zustand (Simpler Alternative)**
- **Status**: Lightweight, popular
- **Approach**: Simple state management with middleware
- **Use Case**: Simpler wizards without complex state machines

**Example:**
```typescript
import create from 'zustand'

interface WizardState {
  step: number
  data: Record<string, any>
  errors: Record<string, string>
  setStep: (step: number) => void
  setData: (key: string, value: any) => void
  setErrors: (errors: Record<string, string>) => void
  next: () => void
  back: () => void
}

const useWizardStore = create<WizardState>((set) => ({
  step: 0,
  data: {},
  errors: {},
  setStep: (step) => set({ step }),
  setData: (key, value) => set((state) => ({
    data: { ...state.data, [key]: value },
  })),
  setErrors: (errors) => set({ errors }),
  next: () => set((state) => ({ step: state.step + 1 })),
  back: () => set((state) => ({ step: Math.max(0, state.step - 1) })),
}))
```

#### B. Form Libraries

**1. React Hook Form**
- **Status**: Most popular, performant
- **Approach**: Uncontrolled components with refs
- **Features**:
  - Minimal re-renders
  - Built-in validation (Yup, Zod)
  - Field-level validation
  - Async validation

**Pattern:**
```typescript
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'

const schema = z.object({
  source: z.string().min(1, 'Source is required'),
  target: z.string().min(1, 'Target is required'),
  rules: z.array(z.object({
    field: z.string(),
    operator: z.string(),
    value: z.string(),
  })).min(1, 'At least one rule required'),
})

function WizardStep({ step, onNext, onBack }) {
  const { register, handleSubmit, formState: { errors } } = useForm({
    resolver: zodResolver(schema),
    mode: 'onBlur',
  })
  
  const onSubmit = (data) => {
    onNext(data)
  }
  
  return <form onSubmit={handleSubmit(onSubmit)}>...</form>
}
```

**2. Formik**
- **Status**: Mature, widely used
- **Approach**: Controlled components
- **Note**: Less performant than React Hook Form, but simpler API

#### C. Progress Tracking Patterns

**1. URL-Based Progress**
- Store current step in URL (`/wizard/step-2`)
- Enables browser back/forward
- Shareable URLs
- **Implementation**: React Router + state

**2. State-Based Progress**
- Store step in component state or global state
- Simpler implementation
- No URL benefits
- **Implementation**: useState or Zustand

**3. Hybrid Approach**
- URL reflects current step
- State manages form data
- **Best Practice**: Use URL for step, state for data

**Example:**
```typescript
// URL: /wizard/reconciliation?step=2
// State: { source: '...', target: '...', rules: [...] }

function Wizard() {
  const [searchParams, setSearchParams] = useSearchParams()
  const step = parseInt(searchParams.get('step') || '0')
  const [formData, setFormData] = useState({})
  
  const next = (stepData) => {
    setFormData({ ...formData, ...stepData })
    setSearchParams({ step: String(step + 1) })
  }
  
  const back = () => {
    setSearchParams({ step: String(Math.max(0, step - 1)) })
  }
}
```

#### D. Validation Patterns

**1. Step-Level Validation**
- Validate current step before allowing next
- Show errors inline
- Block progression until valid

**2. Cross-Step Validation**
- Validate dependencies between steps
- Example: Step 3 depends on Step 1 data
- Show warnings/errors on affected steps

**3. Async Validation**
- Validate against server (e.g., check if source exists)
- Show loading state during validation
- Debounce to avoid excessive API calls

**Example:**
```typescript
const validateStep = async (step: number, data: any) => {
  switch (step) {
    case 0:
      // Validate source selection
      if (!data.source) {
        return { source: 'Source is required' }
      }
      // Async check
      const exists = await checkSourceExists(data.source)
      if (!exists) {
        return { source: 'Source does not exist' }
      }
      return {}
    case 1:
      // Validate target
      return validateTarget(data.target)
    default:
      return {}
  }
}
```

#### E. Navigation Patterns

**1. Linear Navigation**
- Simple next/back buttons
- No skipping steps
- **Use Case**: Simple wizards

**2. Non-Linear Navigation**
- Sidebar with step list
- Click to jump to step (if validated)
- **Use Case**: Complex wizards with many steps

**3. Conditional Steps**
- Show/hide steps based on previous selections
- **Implementation**: State machine guards or conditional rendering

**Example:**
```typescript
const steps = [
  { id: 'source', component: SourceStep },
  { id: 'target', component: TargetStep },
  { 
    id: 'advanced', 
    component: AdvancedStep,
    condition: (data) => data.enableAdvanced === true,
  },
  { id: 'review', component: ReviewStep },
]

// Filter steps based on condition
const visibleSteps = steps.filter(step => 
  !step.condition || step.condition(formData)
)
```

#### F. Recommended Stack

**For Complex Wizards:**
- **XState**: For state machine logic
- **React Hook Form**: For form state and validation
- **Zod**: For schema validation
- **React Router**: For URL-based progress

**For Simpler Wizards:**
- **Zustand**: For state management
- **React Hook Form**: For forms
- **URL params**: For progress tracking

**Pattern:**
```typescript
// Combine XState + React Hook Form
function Wizard() {
  const [state, send] = useMachine(wizardMachine)
  const form = useForm()
  
  // Sync form data with state machine context
  useEffect(() => {
    if (state.context.formData) {
      form.reset(state.context.formData)
    }
  }, [state.context.formData])
  
  const handleNext = async (data) => {
    const valid = await form.trigger()
    if (valid) {
      send({ type: 'NEXT', data })
    }
  }
  
  return <form onSubmit={form.handleSubmit(handleNext)}>...</form>
}
```

---

## 5. Recommended Architecture Summary

### Transaction Matching
- **Matching Engine**: Custom Python/TypeScript with `rapidfuzz`/`fuse.js`
- **Indexing**: Redis for hot data, PostgreSQL for persistence
- **Architecture**: Event-driven (Kafka/Kinesis) for real-time, batch for bulk
- **State**: PostgreSQL with status tracking (`pending`, `matched`, `unmatched`, `review`)

### Workflow Automation
- **Primary**: Temporal.io for agentic workflows, approvals, long-running processes
- **Secondary**: Prefect for scheduled batch jobs and data pipelines
- **Integration**: Event-driven via Kafka/events

### Frontend Data Grids
- **Virtualization**: TanStack Virtual
- **Grid Library**: TanStack Table (React Table)
- **Data Processing**: Web Workers for heavy operations
- **Caching**: React Query for server data

### Multi-Step Wizards
- **State Management**: XState for complex flows, Zustand for simpler ones
- **Forms**: React Hook Form with Zod validation
- **Progress**: URL-based with React Router
- **Navigation**: Conditional steps with state machine guards

---

## 6. Open Questions

1. **Transaction Matching**:
   - What is the expected transaction volume? (affects architecture choice)
   - Is real-time matching required or batch sufficient?
   - What matching confidence threshold for auto-matching?

2. **Workflow Automation**:
   - What is the expected workflow complexity? (affects Temporal vs simpler solutions)
   - Are visual workflow designers required by business users?
   - What is the expected workflow duration? (affects Temporal vs DAG choice)

3. **Data Grids**:
   - What is the maximum expected row count? (affects virtualization vs pagination)
   - Is server-side or client-side filtering/sorting preferred?
   - Are real-time updates required? (affects WebSocket/SSE integration)

4. **Wizards**:
   - How many steps expected? (affects XState vs simpler solutions)
   - Are conditional steps required? (affects state machine complexity)
   - Is wizard state persistence required? (affects storage strategy)

---

## References

### Transaction Matching
- [RapidFuzz Documentation](https://rapidfuzz.github.io/rapidfuzz/)
- [Fuse.js Documentation](https://fusejs.io/)
- [BlackLine Architecture Patterns](https://www.blackline.com/) (public documentation)

### Workflow Automation
- [Temporal.io Documentation](https://docs.temporal.io/)
- [Prefect Documentation](https://docs.prefect.io/)
- [Camunda BPMN Guide](https://docs.camunda.org/)

### Frontend Performance
- [TanStack Virtual Documentation](https://tanstack.com/virtual/latest)
- [TanStack Table Documentation](https://tanstack.com/table/latest)
- [Web Workers API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API)

### State Management
- [XState Documentation](https://xstate.js.org/docs/)
- [React Hook Form Documentation](https://react-hook-form.com/)
- [Zustand Documentation](https://github.com/pmndrs/zustand)
