import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  group('Layout indexes', () {
    test('Indexes', () {
      final DockingItem itemA = dockingItem('a');
      final DockingItem itemB = dockingItem('b');
      final DockingItem itemC = dockingItem('c');
      final DockingItem itemD = dockingItem('d');
      final DockingItem itemE = dockingItem('e');
      final DockingRow row = DockingRow([itemB, itemC]);
      final DockingTabs tabs = DockingTabs([itemD, itemE]);
      final DockingColumn column = DockingColumn([itemA, row, tabs]);
      final DockingLayout layout = DockingLayout(root: column);
      expect(column.index, 1);
      expect(itemA.index, 2);
      expect(row.index, 3);
      expect(itemB.index, 4);
      expect(itemC.index, 5);
      expect(tabs.index, 6);
      expect(itemD.index, 7);
      expect(itemE.index, 8);
      expect(layout.hierarchy(indexInfo: true), 'C1(I2,R3(I4,I5),T6(I7,I8))');
    });
  });
}
