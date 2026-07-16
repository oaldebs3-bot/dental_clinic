import 'package:flutter/material.dart';

class CashierScreen extends StatelessWidget {
  const CashierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الصندوق')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  Text('المبلغ المتبقي', style: TextStyle(color: Colors.grey)),
                  Text('3,200,000 ل.س', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange)),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'البحث عن مريض', prefixIcon: Icon(Icons.search))),
            const SizedBox(height: 16),
            Expanded(child: ListView.builder(
              itemCount: 10,
              itemBuilder: (_, i) => Card(
                child: ListTile(
                  title: Text('مريض ${i + 1}'),
                  subtitle: Text('المتبقي: ${(i + 1) * 100}000 ل.س'),
                  trailing: TextButton(onPressed: () {}, child: const Text('تسديد')),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
