import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  group('remove item by id', () {
    test('item', () {
      final DockingItem item = dockingItem('a', id: 1);
      final DockingLayout layout = DockingLayout(root: item);
      testHierarchy(layout, 'Ia');
      removeItemById(layout, <dynamic>[1]);
      testHierarchy(layout, '');
    });

    test('empty layout', () {
      final DockingLayout layout = DockingLayout();
      removeItemById(layout, <dynamic>[1]);
      testHierarchy(layout, '');
    });

    test('row item 1', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingRow row = DockingRow(<DockingArea>[itemA, itemB, itemC]);
      final DockingLayout layout = DockingLayout(root: row);

      testHierarchy(layout, 'R(Ia,Ib,Ic)');

      removeItemById(layout, <dynamic>[1]);

      testHierarchy(layout, 'R(Ib,Ic)');
    });

    test('row item 2', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingRow row = DockingRow(<DockingArea>[itemA, itemB]);
      final DockingLayout layout = DockingLayout(root: row);

      testHierarchy(layout, 'R(Ia,Ib)');

      removeItemById(layout, <dynamic>[1]);

      testHierarchy(layout, 'Ib');
    });

    test('column item 1', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingColumn column = DockingColumn(<DockingArea>[itemA, itemB, itemC]);
      final DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(Ia,Ib,Ic)');

      removeItemById(layout, <dynamic>[1]);

      testHierarchy(layout, 'C(Ib,Ic)');
    });

    test('column item 2', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingColumn column = DockingColumn(<DockingArea>[itemA, itemB]);
      final DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(Ia,Ib)');

      removeItemById(layout, <dynamic>[1]);

      testHierarchy(layout, 'Ib');
    });

    test('tabs item 1', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingTabs tabs = DockingTabs(<DockingItem>[itemA, itemB, itemC]);
      final DockingLayout layout = DockingLayout(root: tabs);

      testHierarchy(layout, 'T(Ia,Ib,Ic)');

      removeItemById(layout, <dynamic>[1]);

      testHierarchy(layout, 'T(Ib,Ic)');
    });

    test('tabs item 2', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingTabs tabs = DockingTabs(<DockingItem>[itemA, itemB]);
      final DockingLayout layout = DockingLayout(root: tabs);

      testHierarchy(layout, 'T(Ia,Ib)');

      removeItemById(layout, <dynamic>[1]);

      testHierarchy(layout, 'Ib');
    });

    test('tabs item 3', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingTabs tabs = DockingTabs(<DockingItem>[itemA, itemB]);
      final DockingLayout layout = DockingLayout(root: tabs);

      testHierarchy(layout, 'T(Ia,Ib)');

      removeItemById(layout, <dynamic>[1, 2]);

      testHierarchy(layout, '');
    });

    test('column row item 1', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingRow row = DockingRow(<DockingArea>[itemA, itemB]);
      final DockingColumn column = DockingColumn(<DockingArea>[row, itemC]);
      final DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(R(Ia,Ib),Ic)');

      removeItemById(layout, <dynamic>[3]);

      testHierarchy(layout, 'R(Ia,Ib)');
    });

    test('column row item 2', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingRow row = DockingRow(<DockingArea>[itemA, itemB]);
      final DockingColumn column = DockingColumn(<DockingArea>[row, itemC]);
      final DockingLayout layout = DockingLayout(root: column);

      testHierarchy(layout, 'C(R(Ia,Ib),Ic)');

      removeItemById(layout, <dynamic>[1]);

      testHierarchy(layout, 'C(Ib,Ic)');
    });

    test('row column row item', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingItem itemD = dockingItem('d', id: 4);
      final DockingRow row = DockingRow(<DockingArea>[itemB, itemC]);
      final DockingColumn column = DockingColumn(<DockingArea>[row, itemD]);
      final DockingRow rootRow = DockingRow(<DockingArea>[itemA, column]);
      final DockingLayout layout = DockingLayout(root: rootRow);

      testHierarchy(layout, 'R(Ia,C(R(Ib,Ic),Id))');

      removeItemById(layout, <dynamic>[4]);

      testHierarchy(layout, 'R(Ia,Ib,Ic)');
    });

    test('row column row item (2)', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingItem itemD = dockingItem('d', id: 4);
      final DockingRow row = DockingRow(<DockingArea>[itemB, itemC]);
      final DockingColumn column = DockingColumn(<DockingArea>[row, itemD]);
      final DockingRow rootRow = DockingRow(<DockingArea>[itemA, column]);
      final DockingLayout layout = DockingLayout(root: rootRow);

      testHierarchy(layout, 'R(Ia,C(R(Ib,Ic),Id))');
      removeItemById(layout, <dynamic>[1, 4]);

      testHierarchy(layout, 'R(Ib,Ic)');
    });

    test('row column row item (3)', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingItem itemD = dockingItem('d', id: 4);
      final DockingRow row = DockingRow(<DockingArea>[itemB, itemC]);
      final DockingColumn column = DockingColumn(<DockingArea>[row, itemD]);
      final DockingRow rootRow = DockingRow(<DockingArea>[itemA, column]);
      final DockingLayout layout = DockingLayout(root: rootRow);

      testHierarchy(layout, 'R(Ia,C(R(Ib,Ic),Id))');
      removeItemById(layout, <dynamic>[1, 3]);

      testHierarchy(layout, 'C(Ib,Id)');
    });

    test('row column row item (4)', () {
      final DockingItem itemA = dockingItem('a', id: 1);
      final DockingItem itemB = dockingItem('b', id: 2);
      final DockingItem itemC = dockingItem('c', id: 3);
      final DockingItem itemD = dockingItem('d', id: 4);
      final DockingRow row = DockingRow(<DockingArea>[itemB, itemC]);
      final DockingColumn column = DockingColumn(<DockingArea>[row, itemD]);
      final DockingRow rootRow = DockingRow(<DockingArea>[itemA, column]);
      final DockingLayout layout = DockingLayout(root: rootRow);

      testHierarchy(layout, 'R(Ia,C(R(Ib,Ic),Id))');
      removeItemById(layout, <dynamic>[1, 2, 3]);

      testHierarchy(layout, 'Id');
    });
  });
}
