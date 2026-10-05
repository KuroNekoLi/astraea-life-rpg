# M6 — Function Graph and Weak Node Scenario

## Delivered

- Pure Dart Function runtime separates authored graph, active execution state, and player analysis knowledge.
- Analysis only reveals a weak node when the authored rule matches and the supplied roll/modifier meets the content difficulty.
- Interruption requires the active interruptible node to be analyzed; the authored Ashfang LockTarget rule cancels downstream Pounce.
- The Function tutorial shows active/known/cancelled states with text, icons and semantic labels so state is not color-only.
- The tutorial uses a seeded roll for reproducible behavior and allows retries.

## Explicit content limitation

Ashfang function-analyze difficulty 12 and tutorial seed 417 are versioned illustrative content, marked awaiting playtest. They are not approved combat balance. The tutorial outcome is tested as a Function behavior scenario; it is not yet wired into a complete battle screen or a saved battle command flow.

## Verification

- Pure Dart tests cover successful reveal, cancellation, no interruption before analysis, and graph-edge progression.
- Widget test exercises the Ashfang tutorial through cancelled Pounce.
- Encounter content validation: PASS.
