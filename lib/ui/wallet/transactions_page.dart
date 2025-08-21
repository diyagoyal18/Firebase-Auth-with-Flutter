import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Payments', 'Top-ups'];
    final items = List.generate(15, (i) => i);

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: 'Search by note or amount',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: filters.map((f) {
                final selected = _filter == f;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: selected,
                    onSelected: (_) => setState(() => _filter = f),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final isPayment = i.isOdd;
                final title = isPayment ? 'Payment #${i + 1}' : 'Top-up #${i + 1}';
                final subtitle = isPayment ? 'Cafe POS' : 'UPI';
                final amount = isPayment ? '- ₹${(50 * (i + 1))}' : '+ ₹${(100 * (i + 1))}';
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(isPayment ? Icons.south_west : Icons.north_east),
                    ),
                    title: Text(title),
                    subtitle: Text(subtitle),
                    trailing: Text(amount, style: const TextStyle(fontWeight: FontWeight.w600)),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => TransactionDetailPage(
                          title: title,
                          subtitle: subtitle,
                          amount: amount,
                          id: 'TXN${10000 + i}',
                          date: DateTime.now().subtract(Duration(days: i)),
                        ),
                      ));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionDetailPage extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final String amount;
  final DateTime date;

  const TransactionDetailPage({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text(title),
              subtitle: Text(subtitle),
              trailing: Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('Transaction ID'),
              subtitle: Text(id),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Date'),
              subtitle: Text(date.toString()),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share),
            label: const Text('Share receipt'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.file_download_outlined, color: cs.primary),
            label: const Text('Download PDF'),
          ),
        ],
      ),
    );
  }
}