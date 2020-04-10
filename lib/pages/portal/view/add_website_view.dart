import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/resources/storage_provider.dart';
import 'package:acs_upb_mobile/widgets/circle_image.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AddWebsiteView extends StatefulWidget {
  static const String routeName = '/add_website';

  @override
  _AddWebsiteViewState createState() => _AddWebsiteViewState();
}

class _AddWebsiteViewState extends State<AddWebsiteView> {
  final _formKey = GlobalKey<FormState>();
  final _labelKey = GlobalKey<FormFieldState>();
  final _linkKey = GlobalKey<FormFieldState>();

  WebsiteCategory _selectedCategory = WebsiteCategory.learning;
  TextEditingController _labelController = TextEditingController();
  TextEditingController _linkController = TextEditingController();

  // The "Only me" and "Anyone" relevance options are mutually exclusive
  SelectableController _onlyMeController = SelectableController();
  SelectableController _anyoneController = SelectableController();

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      AppToast.show(S.of(context).errorCouldNotLaunchURL(url));
    }
  }

  // Icon color from InputDecoration
  Color get _iconColor {
    ThemeData themeData = Theme.of(context);

    switch (themeData.brightness) {
      case Brightness.dark:
        return Colors.white70;
      case Brightness.light:
        return Colors.black45;
      default:
        return themeData.iconTheme.color;
    }
  }

  Widget preview() => Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 8.0, top: 8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.remove_red_eye, color: _iconColor),
                SizedBox(width: 12.0),
                Text(
                  S.of(context).labelPreview + ':',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FutureBuilder<ImageProvider<dynamic>>(
                        future:
                            Provider.of<StorageProvider>(context, listen: false)
                                .getImageFromPath('icons/websites/globe.png'),
                        builder: (context, snapshot) {
                          ImageProvider<dynamic> image =
                              AssetImage('assets/images/white.png');
                          if (snapshot.hasData) {
                            image = snapshot.data;
                          }
                          return CircleImage(
                            label: _labelController.text,
                            onTap: () => _launchURL(_linkController.text),
                            image: image,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                        child: CircleImage(
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                          label: "",
                          circleScaleFactor: 0.6,
                          // Only align when there is no other website in the category
                          alignWhenScaling: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: S.of(context).actionAddWebsite,
      enableMenu: true,
      menuText: S.of(context).buttonSave,
      menuAction: () async {
        if (_formKey.currentState.validate()) {
          bool res = await Provider.of<WebsiteProvider>(context, listen: false)
              .addWebsite(
            Website(
              label: _labelController.text,
              link: _linkController.text,
              category: _selectedCategory,
            ),
            userOnly: _onlyMeController.isSelected,
            context: context,
          );
          if (res) {
            Navigator.of(context).pop();
          }
        }
      },
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            preview(),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      key: _labelKey,
                      controller: _labelController,
                      decoration: InputDecoration(
                        labelText: S.of(context).labelName,
                        prefixIcon: Icon(Icons.label),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    DropdownButtonFormField<WebsiteCategory>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: S.of(context).labelCategory,
                        prefixIcon: Icon(Icons.category),
                      ),
                      value: _selectedCategory,
                      items: WebsiteCategory.values
                          .map(
                            (category) => DropdownMenuItem<WebsiteCategory>(
                              value: category,
                              child: Text(category.toLocalizedString(context)),
                            ),
                          )
                          .toList(),
                      onChanged: (selection) =>
                          setState(() => _selectedCategory = selection),
                    ),
                    TextFormField(
                      key: _linkKey,
                      controller: _linkController,
                      decoration: InputDecoration(
                        labelText: S.of(context).labelLink,
                        prefixIcon: Icon(Icons.public),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return S.of(context).warningInvalidURL;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 12.0, left: 28.0, right: 16.0),
              child: Row(
                children: <Widget>[
                  Icon(CustomIcons.filter, color: _iconColor),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          S.of(context).labelRelevance,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .apply(color: Theme.of(context).hintColor),
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Selectable(
                                label: S.of(context).relevanceOnlyMe,
                                initiallySelected: true,
                                onSelected: (selected) => setState(() =>
                                    selected
                                        ? _anyoneController.deselect()
                                        : _anyoneController.select()),
                                controller: _onlyMeController,
                              ),
                              SizedBox(width: 8.0),
                              Selectable(
                                label: S.of(context).relevanceAnyone,
                                initiallySelected: false,
                                onSelected: (selected) => setState(() =>
                                    selected
                                        ? _onlyMeController.deselect()
                                        : _onlyMeController.select()),
                                controller: _anyoneController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
