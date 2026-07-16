import 'package:flutter/material.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المواعيد')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(
              labelText: 'بحث عن مريض', prefixIcon: Icon(Icons.search),
            )),
            const SizedBox(height: 16),
            Expanded(child: ListView.builder(
              itemCount: 10,
              itemBuilder: (_, i) => Card(
                child: ListTile(
                  title: Text('مريض ${i + 1}'),
                  subtitle: Text('${9 + i}:00 - ${i % 2 == 0 ? "حشو" : "خلع"}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () {}),
                      IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () {}),
                    ],
                  ),
                ),
              ),
            )),
            SizedBox(
              width: double.infinity, height: 48,
              child: ElevatedButton.icon(
                onPressed: () {}, icon: const Icon(Icons.add),
                label: const Text('حجز موعد جديد'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
