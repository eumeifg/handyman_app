import 'package:flutter/material.dart';
import 'package:sun3ah_provider/components/view_all_label_component.dart';
import 'package:sun3ah_provider/main.dart';
import 'package:sun3ah_provider/provider/jobRequest/job_list_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../jobRequest/components/job_item_widget.dart';
import '../jobRequest/models/post_job_data.dart';

class JobListComponent extends StatelessWidget {
  final List<PostJobData> list;

  JobListComponent({required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: languages!.jobRequestList,
          list: list.validate(),
          onTap: () {
            JobListScreen().launch(context);
          },
        ),
        AnimatedListView(
          itemCount: list.validate().length,
          shrinkWrap: true,
          itemBuilder: (_, i) => JobItemWidget(data: list[i]),
        ),
      ],
    );
  }
}
