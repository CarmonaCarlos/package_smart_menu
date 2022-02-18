import 'package:flutter/material.dart';
import 'package:smart_common_shared/smart_common_shared.dart';
import 'package:smart_translation/smart_translation.dart';

class SmartResponsiveMenu extends StatefulWidget {
  final List<GroupMenu> menu;
  final User userInformation;

  final Function(String screenName, String screenRoute) onDrawerItemChanged;
  final String selectedRoute;
  final String homeRoute;
  final String homeTitleResource;

  const SmartResponsiveMenu(
      {Key? key,
      required this.menu,
      required this.onDrawerItemChanged,
      required this.selectedRoute,
      required this.homeRoute,
      required this.homeTitleResource,
      required this.userInformation})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SmartResponsiveMenu();
}

class _SmartResponsiveMenu extends State<SmartResponsiveMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Row(children: <Widget>[
      Expanded(
          child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountEmail: Text(widget.userInformation.email),
              accountName: Text(widget.userInformation.userName),
              currentAccountPicture: CircleAvatar(
                radius: 128.0,
                backgroundImage: NetworkImage(widget.userInformation.urlPhoto),
                //ExactAssetImage(widget.userInformation.profilePictureUrl),
                backgroundColor: Colors.transparent,
              )),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.translate(
                  SmartApplications.app_smart_maint, widget.homeTitleResource),
              style: const TextStyle(fontSize: 14),
            ),
            leading: const Icon(Icons.home),
            onTap: () {
              widget.onDrawerItemChanged(
                  AppLocalizations.of(context)!.translate(
                      SmartApplications.app_smart_maint, widget.homeTitleResource),
                  widget.homeRoute);
            },
            selected: widget.selectedRoute == widget.homeRoute,
          ),
          Scrollbar(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 250,
                child: _buildMenuItems(widget.menu),
              ),
          ),
        ],
      )),
    ]));
  }

  ListView _buildMenuItems(List<GroupMenu> menuItem) {
    return ListView.builder(
      itemCount: menuItem.length,
      itemBuilder: (BuildContext context, int i) {
        return ExpansionTile(
          initiallyExpanded: true, //TODO: load this from user preferences
          title: Text(
            AppLocalizations.of(context)!
                .translate(SmartApplications.app_smart_maint, menuItem[i].name),
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            Column(
              children: _buildExpandableContent(menuItem[i].items),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildExpandableContent(List<MenuItem> innerContent) {
    List<Widget> options = [];
    for (MenuItem element in innerContent) {
      options.add(
        ListTile(
          title: Text(
            AppLocalizations.of(context)!
                .translate(SmartApplications.app_smart_maint, element.name),
            style:
                const TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
          ),
          leading: _getIcon(element.icon),
          onTap: () {
            widget.onDrawerItemChanged(
                AppLocalizations.of(context)!
                    .translate(SmartApplications.app_smart_maint, element.name),
                element.route);
          },
          selected: widget.selectedRoute == element.route,
        ),
      );
    }
    return options;
  }
}

Icon _getIcon(String menuItemTitle) {
  try {
    return Icon(smartIcons[menuItemTitle]);
  } catch (ex) {
    return const Icon(Icons.device_unknown);
  }
}
