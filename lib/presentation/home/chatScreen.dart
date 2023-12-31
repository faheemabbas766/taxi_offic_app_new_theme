import 'package:flutter/material.dart';
import '../../Api & Routes/routes.dart';
import '../constance/constance.dart';
import '../Language/appLocalizations.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    RouteManager.context=context;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SizedBox(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
              ),
            ),
            Text(
              AppLocalizations.of('Esther Berry'),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(right: 14, left: 10),
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('Today at 5:03 PM'),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).disabledColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          AppLocalizations.of('Hello,are you nearby?'),
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                color: Theme.of(context).textTheme.titleLarge!.color,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          AppLocalizations.of('Hello,are you nearby?'),
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                color: ConstanceData.secoundryFontColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          AppLocalizations.of('OK, Iam waiting at Vinmark\nStore'),
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                color: Theme.of(context).textTheme.titleLarge!.color,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('5:33 PM'),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).disabledColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          AppLocalizations.of('Sorry, i am stuck in traffic.\nplease give me amoment'),
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                color: ConstanceData.secoundryFontColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          AppLocalizations.of('ok'),
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                color: Theme.of(context).textTheme.titleLarge!.color,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Container(
              height: 40,
              padding: EdgeInsets.only(right: 14, left: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      autofocus: false,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).textTheme.titleLarge!.color,
                          ),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of('Type a message...'),
                        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).dividerColor,
                            ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appbar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              child: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).textTheme.titleLarge!.color,
              ),
            ),
          ),
          Text(
            AppLocalizations.of('Esther Berry'),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
          ),
          SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }
}
