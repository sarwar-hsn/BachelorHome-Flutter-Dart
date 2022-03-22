import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stest/others/constants.dart';

class HomepageScreen extends StatelessWidget {
  final String title;

  const HomepageScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GridView(
          padding: const EdgeInsets.only(top: 30, left: 5, right: 5),
          children: [
            _pageCards(
                title: 'profile',
                onTap: () {
                  Navigator.of(context).pushNamed(Constants.profileRoute);
                }),
            _pageCards(
              title: 'request ledger',
              onTap: () {
                Navigator.of(context).pushNamed(Constants.requestLedger);
              },
            ),
            _pageCards(
                title: 'ledger log',
                onTap: () {
                  Navigator.of(context).pushNamed(Constants.ledgerLog);
                }),
            _pageCards(
                title: 'pending ledgers',
                onTap: () {
                  Navigator.of(context).pushNamed(Constants.pendingLedgers);
                }),
            _pageCards(title: 'assgin a task', onTap: () {}),
            InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Card(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: Icon(Icons.logout),
                  ),
                ),
              ),
            )
          ],
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2)),
    );
  }

  Widget _pageCards({required String title, required Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: SizedBox(
          height: 200,
          width: 200,
          child: Center(
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
