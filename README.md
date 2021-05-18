# C#

- Add `GOOGLE_PROTOBUF_REFSTRUCT_COMPATIBILITY_MODE` compiler variable to enable compilation without reflection (C# 7.3, or pre-roslyn. May work better for il2cpp pipelines)

- "ControlEvent" has a flaw in design coupling subprotocols in the main protocol. We should seek consistency.

- Naming in messages is utterly broken, many messages are named "Report" where those are Responses to requests. "Report" is a proactive naming, for notifications. Examples:
  - `SendScreenshot {id, data}` the name should be `ScreenshotResponse { requestId, data }`
  - `ReportBuilderCameraTarget{id,vec3}` should be `BuilderRaycastResponse{id,vec3}`
