import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  group('remove item by id', () {
    test('item', () {
      final DockingItem item = dockingItem('a', id: 1);
      final DockingLayout layout = DockingLayout(root: item);
      testHierarchy(layout, 'Ia');
      removeItemById(layout, [1]);
      testHierarchy(layout, '');
    });

    test('empty layout', () {
      final DockingLayout layout = DockingLayout();
      removeItemById(layout, [1]);
      testHierarchy(layout, '');
    });

    test('row item 1', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingRow row = DockingRow([itemA, itemB, itemC]);
      final DockingLayout layout = DockingLayout(root: row);

      testHierarchy(layout, 'R(Ia,Ib,Ic)');

      removeItemById(layout, [1]);

      testHierarchy(layout, 'R(Ib,Ic)');
    });

    test('row item 2', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingRow row = DockingRow([itemA, itemB]);
      final DockingLayout layout = DockingLayout(root: row);

      testHierarchy(layout, 'R(Ia,Ib)');

      removeItemById(layout, [1]);

      testHierarchy(layout, 'Ib');
    });

    test('column item 1', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingColumn column = DockingColumn([itemA, itemB, itemC]);
      final DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(Ia,Ib,Ic)');

      removeItemById(layout, [1]);

      testHierarchy(layout, 'C(Ib,Ic)');
    });

    test('column item 2', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingColumn column = DockingColumn([itemA, itemB]);
      final DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(Ia,Ib)');

      removeItemById(layout, [1]);

      testHierarchy(layout, 'Ib');
    });

    test('tabs item 1', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingTabs tabs = DockingTabs([itemA, itemB, itemC]);
      final DockingLayout layout = DockingLayout(root: tabs);

      testHierarchy(layout, 'T(Ia,Ib,Ic)');

      removeItemById(layout, [1]);

      testHierarchy(layout, 'T(Ib,Ic)');
    });

    test('tabs item 2', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingTabs tabs = DockingTabs([itemA, itemB]);
      final DockingLayout layout = DockingLayout(root: tabs);

      testHierarchy(layout, 'T(Ia,Ib)');

      removeItemById(layout, [1]);

      testHierarchy(layout, 'Ib');
    });

    test('tabs item 3', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingTabs tabs = DockingTabs([itemA, itemB]);
      final DockingLayout layout = DockingLayout(root: tabs);

      testHierarchy(layout, 'T(Ia,Ib)');

      removeItemById(layout, [1, 2]);

      testHierarchy(layout, '');
    });

    test('column row item 1', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingRow row = DockingRow([itemA, itemB]);
      final DockingColumn column = DockingColumn([row, itemC]);
      final DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(R(Ia,Ib),Ic)');

      removeItemById(layout, [3]);

      testHierarchy(layout, 'R(Ia,Ib)');
    });

    test('column row item 2', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingRow row = DockingRow([itemA, itemB]);
      final DockingColumn column = DockingColumn([row, itemC]);
      final DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(R(Ia,Ib),Ic)');

      removeItemById(layout, [1]);

      testHierarchy(layout, 'C(Ib,Ic)');
    });

    test('row column row item', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingItem itemD = dockingItem('d', id: 4);
      final DockingRow row = DockingRow([itemB, itemC]);
      final DockingColumn column = DockingColumn([row, itemD]);
      final DockingRow rootRow = DockingRow([itemA, column]);
      final DockingLayout layout = DockingLayout(root: rootRow);

      testHierarchy(layout, 'R(Ia,C(R(Ib,Ic),Id))');

      removeItemById(layout, [4]);

      testHierarchy(layout, 'R(Ia,Ib,Ic)');
    });

    test('row column row item (2)', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingItem itemD = dockingItem('d', id: 4);
      final DockingRow row = DockingRow([itemB, itemC]);
      final DockingColumn column = DockingColumn([row, itemD]);
      final DockingRow rootRow = DockingRow([itemA, column]);
      final DockingLayout layout = DockingLayout(root: rootRow);

      testHierarchy(layout, 'R(Ia,C(R(Ib,Ic),Id))');
      removeItemById(layout, [1, 4]);

      testHierarchy(layout, 'R(Ib,Ic)');
    });

    test('row column row item (3)', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingItem itemD = dockingItem('d', id: 4);
      final DockingRow row = DockingRow([itemB, itemC]);
      final DockingColumn column = DockingColumn([row, itemD]);
      final DockingRow rootRow = DockingRow([itemA, column]);
      final DockingLayout layout = DockingLayout(root: rootRow);

      testHierarchy(layout, 'R(Ia,C(R(Ib,Ic),Id))');
      removeItemById(layout, [1, 3]);

      testHierarchy(layout, 'C(Ib,Id)');
    });

    test('row column row item (4)', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingItem itemD = dockingItem('d', id: 4);
      final DockingRow row = DockingRow([itemB, itemC]);
      final DockingColumn column = DockingColumn([row, itemD]);
      final DockingRow rootRow = DockingRow([itemA, column]);
      final DockingLayout layout = DockingLayout(root: rootRow);

      testHierarchy(layout, 'R(Ia,C(R(Ib,Ic),Id))');
      removeItemById(layout, [1, 2, 3]);

      testHierarchy(layout, 'Id');
    });
  });
}
