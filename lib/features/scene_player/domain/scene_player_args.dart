/// Passed via go_router's `extra` when pushing `/play/:sceneId` from
/// story_detail, which is the only screen with access to a scene's
/// `unlock_cost_diamonds` *before* fetching the scene itself — `GET
/// /scenes/:id` refuses to return anything (`402 scene_locked`) for a
/// locked scene, so the player screen has no other way to know what to
/// charge without this being handed to it up front. Entry points that
/// can't supply this (e.g. a bare deep link) fall back to an unpriced
/// locked state — see `ScenePlayerScreen`.
class ScenePlayerArgs {
  const ScenePlayerArgs({required this.storyId, this.unlockCostDiamonds});

  final String storyId;
  final int? unlockCostDiamonds;
}
