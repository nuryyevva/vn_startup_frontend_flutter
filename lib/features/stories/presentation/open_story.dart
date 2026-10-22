import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/coming_soon_snack_bar.dart';
import '../domain/models/story.dart';

/// Opens a story from any list of them. A story that is only listed for now
/// (Story.comingSoon) says so instead — the backend would refuse to play it
/// anyway.
void openStory(BuildContext context, Story story) {
  if (story.comingSoon) {
    showComingSoonSnackBar(context, 'stories.comingSoonToast'.tr());
    return;
  }
  context.push('/story/${story.id}');
}
