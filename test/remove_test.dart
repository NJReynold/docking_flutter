import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  group('remove item', () {
    test('item', () {
      final DockingItem item = dockingItem('a');
      final DockingLayout layout = DockingLayout(root: item);
      testHierarchy(layout, 'Ia');
      removeItem(layout, item);
      testHierarchy(layout, '');
    });

    test('item without layout', () {
      DockingLayout layout = DockingLayout();
      expect(() => removeItem(layout, dockingItem('a')), throwsArgumentError);
      layout = DockingLayout(root: dockingItem('a'));
      expect(() => removeItem(layout, dockingItem('b')), throwsArgumentError);
    });

    test('item from another layout', () {
      final DockingLayout layout1 = DockingLayout(root: dockingItem('a'));
      final DockingLayout layout2 = DockingLayout(root: dockingItem('b'));
      expect(
          () => removeItem(layout2, layout1.layoutAreas().first as DockingItem),
          throwsArgumentError,);
    });

    test('row item 1', () {
      final DockingItem itemA = dockingItem('a');
      final DockingItem itemB = dockingItem('b');
      final DockingItem itemC = dockingItem('c');
      final DockingRow row = DockingRow([itemA, itemB, itemC]);
      final DockingLayout layout = DockingLayout(root: row);

      testHierarchy(layout, 'R(Ia,Ib,Ic)');

      removeItem(layout, itemA);

      testHierarchy(layout, 'R(Ib,Ic)');
    });

    test('row item 2', () {
      final DockingItem itemA = dockingItem('a');
      final DockingItem itemB = dockingItem('b');
      final DockingRow row = DockingRow([itemA, itemB]);
      final DockingLayout layout = DockingLayout(root: row);

      testHierarchy(layout, 'R(Ia,Ib)');

      removeItem(layout, itemA);

      testHierarchy(layout, 'Ib');
    });

    test('column item 1', () {
      final DockingItem itemA = dockingItem('a');
      final DockingItem itemB = dockingItem('b');
      final DockingItem itemC = dockingItem('c');
      final DockingColumn column = DockingColumn([itemA, itemB, itemC]);
      final DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(Ia,Ib,Ic)');

      removeItem(layout, itemA);

      testHierarchy(layout, 'C(Ib,Ic)');
    });

    test('column item 2', () {
      final DockingItem itemA = dockingItem('a');
      final DockingItem itemB = dockingItem('b');
      final DockingColumn column = DockingColumn([itemA, itemB]);
      final DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(Ia,Ib)');

      removeItem(layout, itemA);

      testHierarchy(layout, 'Ib');
    });

    test('tabs single item', () {
      final DockingItem itemA = dockingItem('a');
      final DockingTabs tabs = DockingTabs([itemA]);
      final DockingLayout layout = DockingLayout(root: tabs);

      testHierarchy(layout, 'T(Ia)');

      removeItem(layout, itemA);

      testHierarchy(layout, '');
    });

    test('tabs item 1', () {
      final DockingItem itemA = dockingItem('a');
      final DockingItem itemB = dockingItem('b');
      final DockingItem itemC = dockingItem('c');
      final DockingTabs tabs = DockingTabs([itemA, itemB, itemC]);
      final DockingLayout layout = DockingLayout(root: tabs);

      testHierarchy(layout, 'T(Ia,Ib,Ic)');

      removeItem(layout, itemA);

      testHierarchy(layout, 'T(Ib,Ic)');
    });

    test('tabs item 2', () {
      final DockingItem itemA = dockingItem('a');
      final DockingItem itemB = dockingItem('b');
      final DockingTabs tabs = DockingTabs([itemA, itemB]);
      final DockingLayout layout = DockingLayout(root: tabs);

      testHierarchy(layout, 'T(Ia,Ib)');

      removeItem(layout, itemA);

      testHierarchy(layout, 'Ib');
    });

    test('column row item 1', () {
      final DockingItem itemA = dockingItem('a');
      final DockingItem itemB = dockingItem('b');
      final DockingItem itemC = dockingItem('c');
      final DockingRow row = DockingRow([itemA, itemB]);
      final DockingColumn column = DockingColumn([row, itemC]);
      final DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(R(Ia,Ib),Ic)');

      removeItem(layout, itemC);

      testHierarchy(layout, 'R(Ia,Ib)');
    });

    test('column row item 2', () {
      final DockingItem itemA = dockingItem('a');
      final DockingItem itemB = dockingItem('b');
      final DockingItem itemC = dockingItem('c');
      final DockingRow row = DockingRow([itemA, itemB]);
      final DockingColumn column = DockingColumn([row, itemC]);
      final DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(R(Ia,Ib),Ic)');

      removeItem(layout, itemA);

      testHierarchy(layout, 'C(Ib,Ic)');
    });

    test('row column row item', () {
      final DockingItem itemA = dockingItem('a');
      final DockingItem itemB = dockingItem('b');
      final DockingItem itemC = dockingItem('c');
      final DockingItem itemD = dockingItem('d');
      final DockingRow row = DockingRow([itemB, itemC]);
      final DockingColumn column = DockingColumn([row, itemD]);
      final DockingRow rootRow = DockingRow([itemA, column]);
      final DockingLayout layout = DockingLayout(root: rootRow);

      testHierarchy(layout, 'R(Ia,C(R(Ib,Ic),Id))');

      removeItem(layout, itemD);

      testHierarchy(layout, 'R(Ia,Ib,Ic)');
    });
  });
}
