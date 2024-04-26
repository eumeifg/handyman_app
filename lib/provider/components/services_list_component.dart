import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sun3ah_provider/components/background_component.dart';
import 'package:sun3ah_provider/components/view_all_label_component.dart';
import 'package:sun3ah_provider/main.dart';
import 'package:sun3ah_provider/models/service_model.dart';
import 'package:sun3ah_provider/provider/components/service_widget.dart';
import 'package:sun3ah_provider/provider/services/service_detail_screen.dart';
import 'package:sun3ah_provider/provider/services/service_list_screen.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceListComponent extends StatelessWidget {
  final List<ServiceData> list;

  ServiceListComponent({required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: languages!.lblMyService,
          list: list,
          onTap: () {
            ServiceListScreen().launch(context);
          },
        ),
        16.height,
        Stack(
          children: [
            Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: List.generate(
                list.take(4).length,
                (index) {
                  return ServiceComponent(data: list[index], width: context.width() * 0.5 - 24).onTap(() async {
                    await ServiceDetailScreen(serviceId: list[index].id.validate()).launch(context);
                  }, borderRadius: radius());
                },
              ),
            ),
            Observer(builder: (context) {
              return BackgroundComponent(
                text: languages!.noServiceFound,
                subTitle: languages!.noServiceSubTitle,
              ).visible(!appStore.isLoading && list.validate().isEmpty);
            }),
          ],
        )
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
