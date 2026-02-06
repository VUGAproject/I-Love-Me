# I Love ME (iOS)

SwiftUI prototype for an affirmations app with:
- Typed or pasted affirmations
- On-device TTS with selectable voices
- User recordings (self or loved ones) played in a loop
- Background audio mixing (keeps Spotify, etc. playing)
- Matte theme choices
- White heart logo (SF Symbol placeholder)

## Notes
- This workspace is on Linux, so you cannot build or run iOS here. Open this folder in Xcode on macOS.
- V1 is offline-first as requested. Cloud TTS/voice cloning can be added later.

## Build (macOS)
1. Open the folder in Xcode.
2. Ensure `Info.plist` is included with microphone usage description.
3. Run on a device or simulator.

## V1 Behavior
- The trial voice defaults to `en-NG` if available.
- Recorded audio loops in order and can run alongside other audio apps.
- Starter voices appear at the top; unavailable ones are listed as not installed.

## V2 Cloud TTS and Voice Cloning Plan (Draft)
1. Consent gate
	- First-time modal explaining cloud processing, data retention, and costs.
	- Explicit opt-in checkbox for TTS and a separate opt-in for voice cloning.
2. Voice cloning safety flow
	- Require proof of consent from the voice owner (recorded spoken consent or signed upload).
	- Block names that imply impersonation of public figures.
	- Show a persistent watermark label: "Synthetic voice" when cloning is used.
3. Data handling
	- Encrypt uploads in transit and at rest; auto-delete voice samples after model creation (user-configurable).
	- Allow users to delete their voice models and all related data from settings.
4. UI and UX
	- Add a "Cloud Voices" tab with pricing and quality info.
	- Provide clear fallbacks to on-device voices if network or API fails.
5. Billing and limits
	- Rate-limit requests; show usage meters and estimated cost.
	- Cache synthesized audio for repeated affirmations to reduce spend.
