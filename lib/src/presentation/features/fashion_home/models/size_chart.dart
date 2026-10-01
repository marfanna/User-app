double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

/// One size row in a [SizeChart]. [values] are positional, aligned to the
/// chart's [SizeChart.columns]. Stored in inches; cm is derived on demand.
class SizeChartRow {
  const SizeChartRow({required this.size, required this.values});

  factory SizeChartRow.fromJson(Map<String, dynamic> json) {
    final raw = json['values'] as List<dynamic>?;
    return SizeChartRow(
      size: (json['size'] ?? '') as String,
      values: raw?.map((v) => _toDouble(v) ?? 0).toList() ?? const [],
    );
  }

  final String size;
  final List<double> values; // inches, positional against columns

  /// Same row converted to centimetres (×2.54).
  List<double> get valuesCm => values.map((v) => v * 2.54).toList();
}

/// A reusable Fashion size chart, resolved from the shop's Product container.
/// Columns vary per garment (shirt: Chest/Length/Sleeve; pant: Waist/Inseam),
/// so rows carry positional [SizeChartRow.values].
class SizeChart {
  const SizeChart({
    required this.id,
    required this.name,
    required this.columns,
    required this.rows,
  });

  factory SizeChart.fromJson(Map<String, dynamic> json) {
    final cols = json['columns'] as List<dynamic>?;
    final rows = json['rows'] as List<dynamic>?;
    return SizeChart(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      columns: cols?.whereType<String>().toList() ?? const [],
      rows: rows
              ?.whereType<Map<String, dynamic>>()
              .map(SizeChartRow.fromJson)
              .toList() ??
          const [],
    );
  }

  final String id;
  final String name;
  final List<String> columns;
  final List<SizeChartRow> rows;

  bool get isEmpty => columns.isEmpty || rows.isEmpty;

  /// Parses the `sizeCharts[]` array off a Product container payload and keys
  /// them by id for quick resolution against an item's `sizeChartId`.
  static Map<String, SizeChart> mapFromContainer(Map<String, dynamic>? data) {
    final raw = data?['sizeCharts'] as List<dynamic>?;
    if (raw == null) return const {};
    final out = <String, SizeChart>{};
    for (final c in raw.whereType<Map<String, dynamic>>()) {
      final chart = SizeChart.fromJson(c);
      if (chart.id.isNotEmpty) out[chart.id] = chart;
    }
    return out;
  }
}
