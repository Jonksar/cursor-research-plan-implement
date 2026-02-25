# Command: Analyze Session

This command gathers recent user prompts and sub-agent transcripts, then uses the **Meta Researcher** agent to propose improvements.

## Steps

1.  **Gather Data**:
    Run the analysis script to populate `commands/meta/session_context.md`.
    ```bash
    python3 src/session_analyzer.py
    ```

2.  **Run Meta-Analysis**:
    Call the Meta Researcher to review the context.
    ```bash
    # (Pseudo-command - run this via the Agent or Chat)
    @Meta Researcher Please analyze the latest session context and propose improvements.
    ```

## Output
- `commands/meta/session_context.md`: Raw data (User prompts + Sub-agent logs).
- **Session Retrospective**: The output from the Meta Researcher agent.
