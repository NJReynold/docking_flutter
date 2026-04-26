import 'package:docking/docking.dart';
import 'package:flutter_test/flutter_test.dart';

import 'exceptions.dart';
import 'utils.dart';

void main() {
  group('add item - exceptions', () {
    test('dropItem == targetArea', () {
      final DockingItem item = dockingItem('a');
      final DockingLayout layout = DockingLayout(root: item);
      expect(() => addItemOnRootPosition(layout, item, DropPosition.left),
          sameDraggedItemAndTargetAreaException(),);
    });

    test('area.layoutId != -1', () {
      final DockingItem itemA = dockingItem('a');
      final DockingItem itemB = dockingItem('b');
      final DockingRow row = DockingRow([itemA, itemB]);
      final DockingLayout layout = DockingLayout(root: row);
      expect(() => addItemOn(layout, itemB, itemA, DropPosition.right),
          dockingAreaInSomeLayoutException(),);
    });
  });

  group('add item', () {
    test('item on root - left', () {
      final DockingItem item = dockingItem('a');
      final DockingLayout layout = DockingLayout(root: item);
      addItemOnRootPosition(layout, dockingItem('b'), DropPosition.left);
      testHierarchy(layout, 'R(Ib,Ia)');
    });

    test('item on root - right', () {
      final DockingItem item = dockingItem('a');
      final DockingLayout layout = DockingLayout(root: item);
      addItemOnRootPosition(layout, dockingItem('b'), DropPosition.right);
      testHierarchy(layout, 'R(Ia,Ib)');
    });

    test('item on root - top', () {
      final DockingItem item = dockingItem('a');
      final DockingLayout layout = DockingLayout(root: item);
      addItemOnRootPosition(layout, dockingItem('b'), DropPosition.top);
      testHierarchy(layout, 'C(Ib,Ia)');
    });

    test('item on root - bottom', () {
      final DockingItem item = dockingItem('a');
      final DockingLayout layout = DockingLayout(root: item);
      addItemOnRootPosition(layout, dockingItem('b'), DropPosition.bottom);
      testHierarchy(layout, 'C(Ia,Ib)');
    });

    test('item on root - index 0', () {
      final DockingItem item = dockingItem('a');
      final DockingLayout layout = DockingLayout(root: item);
      addItemOnRootIndex(layout, dockingItem('b'), 0);
      testHierarchy(layout, 'T(Ib,Ia)');
    });

    test('item on root - index 1', () {
      final DockingItem item = dockingItem('a');
      final DockingLayout layout = DockingLayout(root: item);
      addItemOnRootIndex(layout, dockingItem('b'), 1);
      testHierarchy(layout, 'T(Ia,Ib)');
    });

    test('item on row - right', () {
      final DockingItem itemA = dockingItem('a');
      final DockingItem itemB = dockingItem('b');
      final DockingRow row = DockingRow([itemA, itemB]);
      final DockingLayout layout = DockingLayout(root: row);
      addItemOn(layout, dockingItem('c'), itemA, DropPosition.right);
      testHierarchy(layout, 'R(Ia,Ic,Ib)');
    });
  });
}
