
### Explanation:
- **Frequent Access Rule**:
  -  `STANDARD` class for Six month Frequent Access
  - Transitions objects to `STANDARD_IA` (Infrequent Access) after 6 months.
  - Deletes objects 4 years after the transition to `STANDARD_IA`.

- **One-Year Rule**:
  - Transitions objects to `GLACIER` after 1 year.
  - Deletes objects 4 years after the transition to `GLACIER`.

- **Five-Year Rule**:
  - Deletes objects 5 years after creation.

