import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

/// ---------------------------------------------------------------------------
/// Store
/// ---------------------------------------------------------------------------
class StorePage extends StatefulWidget {
  const StorePage({super.key});
  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final list =
        _filter == 'All' ? products : products.where((p) => p.type == _filter).toList();
    return Shell(children: [
      const PageHero(
        eyebrow: 'Store',
        title: 'Digital and physical products',
        subtitle:
            'Workbooks, journals, learning kits and recorded workshops - from MT Alchemy.',
      ),
      Section(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final f in ['All', 'Digital', 'Physical'])
              ChoiceChip(
                label: Text(f),
                selected: _filter == f,
                selectedColor: Brand.purple,
                labelStyle: TextStyle(
                    color: _filter == f ? Colors.white : Brand.deepBlue,
                    fontWeight: FontWeight.w600),
                onSelected: (_) => setState(() => _filter = f),
              ),
          ]),
          const SizedBox(height: 28),
          CardGrid(children: [for (final p in list) ProductCard(p)]),
        ]),
      ),
    ]);
  }
}

/// ---------------------------------------------------------------------------
/// Product Detail
/// ---------------------------------------------------------------------------
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.product});
  final Product product;
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final isDigital = p.type == 'Digital';
    return Shell(children: [
      Section(
        child: LayoutBuilder(builder: (context, box) {
          final wide = box.maxWidth >= 860;
          final image = ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(p.image,
                height: 420, width: double.infinity, fit: BoxFit.cover),
          );
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDigital ? Brand.purple : Brand.deepBlue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('${p.type} Product',
                    style: body(11, color: Colors.white, weight: FontWeight.w700)),
              ),
              const SizedBox(height: 14),
              Text(p.name, style: heading(32)),
              const SizedBox(height: 8),
              Text(p.category, style: body(13, color: Brand.grey)),
              const SizedBox(height: 16),
              Text(p.description, style: body(16, color: Brand.grey)),
              const SizedBox(height: 22),
              Text('RM${p.price.toStringAsFixed(0)}',
                  style: heading(30, color: Brand.deepBlue)),
              const SizedBox(height: 8),
              if (isDigital)
                _info(Icons.cloud_download_outlined, 'Instant download after purchase')
              else
                _info(Icons.inventory_2_outlined, 'In stock: ${p.stock} units'),
              const SizedBox(height: 4),
              if (!isDigital)
                _info(Icons.local_shipping_outlined, 'Shipping required')
              else
                _info(Icons.lock_outline, 'Access verified against your purchase'),
              const SizedBox(height: 20),
              if (!isDigital)
                Row(children: [
                  const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Brand.line),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      IconButton(
                          onPressed: () =>
                              setState(() => _qty = _qty > 1 ? _qty - 1 : 1),
                          icon: const Icon(Icons.remove)),
                      Text('$_qty', style: body(16, weight: FontWeight.w700)),
                      IconButton(
                          onPressed: () => setState(() => _qty++),
                          icon: const Icon(Icons.add)),
                    ]),
                  ),
                ]),
              const SizedBox(height: 22),
              Wrap(spacing: 12, runSpacing: 12, children: [
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${p.name} added to cart')),
                    );
                    go(context, '/cart');
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add to Cart'),
                ),
                OutlinedButton(
                    onPressed: () => go(context, '/store'),
                    child: const Text('Continue Shopping')),
              ]),
            ],
          );
          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: image),
                  const SizedBox(width: 40),
                  Expanded(child: details),
                ])
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  image,
                  const SizedBox(height: 28),
                  details,
                ]);
        }),
      ),
      Section(
        color: Brand.mist,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionHeading('Related products'),
          const SizedBox(height: 24),
          CardGrid(children: [
            for (final r in products.where((x) => x.id != p.id).take(3))
              ProductCard(r),
          ]),
        ]),
      ),
    ]);
  }

  static Widget _info(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(children: [
          Icon(icon, size: 18, color: Brand.purple),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: body(14, color: Brand.grey))),
        ]),
      );
}

/// ---------------------------------------------------------------------------
/// Cart
/// ---------------------------------------------------------------------------
class CartPage extends StatelessWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context) {
    final items = products.take(2).toList();
    final subtotal = items.fold<double>(0, (s, p) => s + p.price);
    const shipping = 12.0;
    final total = subtotal + shipping;
    return Shell(children: [
      Section(
        color: Brand.mist,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Your Cart', style: heading(30)),
          const SizedBox(height: 20),
          LayoutBuilder(builder: (context, box) {
            final wide = box.maxWidth >= 860;
            final list = Column(children: [
              for (final p in items) _cartRow(context, p),
            ]);
            final summary = Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Summary', style: heading(20)),
                  const SizedBox(height: 16),
                  _line('Subtotal', 'RM${subtotal.toStringAsFixed(0)}'),
                  _line('Shipping', 'RM${shipping.toStringAsFixed(0)}'),
                  _line('Discount', '- RM0'),
                  Divider(color: Brand.line),
                  _line('Total', 'RM${total.toStringAsFixed(0)}', bold: true),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: () => Navigator.pushNamed(context, '/checkout'),
                        child: const Text('Proceed to Checkout')),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () => go(context, '/store'),
                        child: const Text('Continue Shopping')),
                  ),
                ],
              ),
            );
            return wide
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 3, child: list),
                    const SizedBox(width: 20),
                    SizedBox(width: 320, child: summary),
                  ])
                : Column(children: [list, const SizedBox(height: 20), summary]);
          }),
        ]),
      ),
    ]);
  }

  static Widget _cartRow(BuildContext context, Product p) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Panel(
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
                  Image.asset(p.image, width: 72, height: 72, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.name, style: body(15, weight: FontWeight.w600)),
                Text('${p.type} · ${p.category}',
                    style: body(12.5, color: Brand.grey)),
              ]),
            ),
            Text('RM${p.price.toStringAsFixed(0)}',
                style: heading(18, color: Brand.deepBlue)),
          ]),
        ),
      );

  static Widget _line(String label, String value, {bool bold = false}) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: body(14, weight: bold ? FontWeight.w700 : FontWeight.w400)),
          Text(value,
              style: body(14, weight: bold ? FontWeight.w700 : FontWeight.w400)),
        ]),
      );
}

/// ---------------------------------------------------------------------------
/// Checkout (Form: customer, billing, shipping + payment)
/// ---------------------------------------------------------------------------
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final bool _hasPhysical = true; // cart contains a physical item
  String _payment = 'Card';

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  void _placeOrder() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, '/order');
    }
  }

  @override
  Widget build(BuildContext context) => Shell(children: [
        Section(
          color: Brand.mist,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Checkout', style: heading(30)),
                  const SizedBox(height: 20),
                  Panel(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Customer information', style: heading(18)),
                      const SizedBox(height: 14),
                      _field('Name', Icons.person_outline),
                      _field('Email', Icons.email_outlined,
                          keyboard: TextInputType.emailAddress),
                      _field('Phone', Icons.phone_outlined,
                          keyboard: TextInputType.phone),
                    ]),
                  ),
                  const SizedBox(height: 18),
                  Panel(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Billing address', style: heading(18)),
                      const SizedBox(height: 14),
                      _field('Address', Icons.home_outlined),
                      Row(children: [
                        Expanded(child: _field('City', Icons.location_city)),
                        const SizedBox(width: 14),
                        Expanded(child: _field('State', Icons.map_outlined)),
                      ]),
                      Row(children: [
                        Expanded(child: _field('Postcode', Icons.markunread_mailbox)),
                        const SizedBox(width: 14),
                        Expanded(child: _field('Country', Icons.public)),
                      ]),
                    ]),
                  ),
                  if (_hasPhysical) ...[
                    const SizedBox(height: 18),
                    Panel(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          const Icon(Icons.local_shipping_outlined, color: Brand.purple),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text('Shipping address',
                                  style: heading(18))),
                        ]),
                        const SizedBox(height: 6),
                        Text('Only required because your cart contains a physical product.',
                            style: body(13, color: Brand.grey)),
                        const SizedBox(height: 14),
                        _field('Shipping Address', Icons.home_work_outlined),
                      ]),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Panel(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Payment method', style: heading(18)),
                      RadioGroup<String>(
                        groupValue: _payment,
                        onChanged: (v) => setState(() => _payment = v!),
                        child: Column(children: [
                          for (final m in ['Card', 'Online Banking', 'E-Wallet'])
                            RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              value: m,
                              activeColor: Brand.purple,
                              title: Text(m),
                            ),
                        ]),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _placeOrder,
                      icon: const Icon(Icons.lock_outline),
                      label: const Text('Place Order'),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ]);

  Widget _field(String label, IconData icon, {TextInputType? keyboard}) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          keyboardType: keyboard,
          decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
          validator: _required,
        ),
      );
}

/// ---------------------------------------------------------------------------
/// Order Confirmation
/// ---------------------------------------------------------------------------
class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(children: [
        Section(
          color: Brand.mist,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Panel(
                padding: const EdgeInsets.all(32),
                child: Column(children: [
                  const Icon(Icons.check_circle, color: Brand.success, size: 64),
                  const SizedBox(height: 16),
                  Text('Thank you for your order.', style: heading(26)),
                  const SizedBox(height: 6),
                  Text('Order #MA1003 · RM211 · Paid',
                      style: body(15, color: Brand.grey)),
                  const SizedBox(height: 24),
                  _item('Emotional Clarity Workbook', 'Digital', 'Download Product'),
                  _item('Mindfulness Journal', 'Physical', 'Track Order'),
                  const SizedBox(height: 24),
                  Wrap(spacing: 12, runSpacing: 12, children: [
                    FilledButton(
                        onPressed: () => go(context, '/library'),
                        child: const Text('My Digital Products')),
                    OutlinedButton(
                        onPressed: () => go(context, '/myorders'),
                        child: const Text('My Orders')),
                  ]),
                ]),
              ),
            ),
          ),
        ),
      ]);

  static Widget _item(String name, String type, String cta) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          Icon(type == 'Digital' ? Icons.cloud_download_outlined : Icons.local_shipping_outlined,
              color: Brand.purple),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: body(14.5, weight: FontWeight.w600))),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(cta),
          ),
        ]),
      );
}

/// ---------------------------------------------------------------------------
/// My Orders
/// ---------------------------------------------------------------------------
class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});
  @override
  Widget build(BuildContext context) => Shell(children: [
        Section(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('My Orders', style: heading(30)),
            const SizedBox(height: 20),
            Panel(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingTextStyle:
                      body(13, color: Brand.deepBlue, weight: FontWeight.w700),
                  dataTextStyle: body(13),
                  columns: const [
                    DataColumn(label: Text('Order')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('')),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('#MA1001')),
                      DataCell(Text('10 Sep 2026')),
                      DataCell(Text('RM120')),
                      DataCell(Text('Paid')),
                      DataCell(Text('View')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('#MA1002')),
                      DataCell(Text('12 Sep 2026')),
                      DataCell(Text('RM85')),
                      DataCell(Text('Shipped')),
                      DataCell(Text('View')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('#MA1003')),
                      DataCell(Text('13 Oct 2026')),
                      DataCell(Text('RM211')),
                      DataCell(Text('Paid')),
                      DataCell(Text('View')),
                    ]),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ]);
}

/// ---------------------------------------------------------------------------
/// Digital Product Library
/// ---------------------------------------------------------------------------
class DigitalLibraryPage extends StatelessWidget {
  const DigitalLibraryPage({super.key});
  @override
  Widget build(BuildContext context) {
    final digital = products.where((p) => p.type == 'Digital').toList();
    return Shell(children: [
      Section(
        color: Brand.mist,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('My Digital Products', style: heading(30)),
          const SizedBox(height: 6),
          Text('Downloads are verified against your purchases.',
              style: body(14, color: Brand.grey)),
          const SizedBox(height: 24),
          CardGrid(children: [
            for (final p in digital)
              Panel(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          color: Brand.lavender,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.description_outlined, color: Brand.purple),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(p.name, style: heading(16))),
                  ]),
                  const SizedBox(height: 12),
                  Text('Purchased: 10 Sep 2026', style: body(12.5, color: Brand.grey)),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Download'),
                    ),
                  ),
                ]),
              ),
          ]),
        ]),
      ),
    ]);
  }
}
