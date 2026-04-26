import 'package:docking/docking.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

DockingItem dockingItem(dynamic id) {
  return DockingItem(id: id, widget: Container());
}

void main() {
  group('find', () {
    test('empty layout', () {
      final DockingLayout layout = DockingLayout();
      expect(layout.findDockingItem(1), isNull);
    });
    test('row', () {
      final DockingItem item1 = dockingItem(1);
      final DockingItem item2 = dockingItem(2);
      final DockingRow row = DockingRow([item1, item2], id: 'row');
      final DockingLayout layout = DockingLayout(root: row);
      expect(layout.findDockingItem(1), item1);
      expect(layout.findDockingItem(2), item2);
      expect(layout.findDockingItem(3), isNull);
      expect(layout.findDockingArea('row'), row);
    });
    test('column', () {
      final DockingItem item1 = dockingItem(1);
      final DockingItem item2 = dockingItem(2);
      final DockingColumn column = DockingColumn([item1, item2], id: 'column');
      final DockingLayout layout = DockingLayout(root: column);
      expect(layout.findDockingItem(1), item1);
      expect(layout.findDockingItem(2), item2);
      expect(layout.findDockingItem(3), isNull);
      expect(layout.findDockingArea('column'), column);
    });

    test('tabs', () {
      final DockingItem item1 = dockingItem(1);
      final DockingItem item2 = dockingItem(2);
      final DockingTabs tabs = DockingTabs([item1, item2], id: 'tabs');
      final DockingLayout layout = DockingLayout(root: tabs);
      expect(layout.findDockingItem(1), item1);
      expect(layout.findDockingItem(2), item2);
      expect(layout.findDockingItem(3), isNull);
      expect(layout.findDockingArea('tabs'), tabs);
    });

    test('tabs with item', () {
      final DockingItem itemA = dockingItem('a');
      final DockingItem itemB = dockingItem('b');
      final DockingItem itemC = dockingItem('c');
      final DockingItem itemD = dockingItem('d');
      final DockingItem itemE = dockingItem('e');
      final DockingColumn innerColumn =
          DockingColumn([itemB, itemC], id: 'innerColumn');
      final DockingRow row = DockingRow([itemA, innerColumn], id: 'row');
      final DockingTabs tabs = DockingTabs([itemD, itemE], id: 'tabs');
      final DockingColumn column = DockingColumn([row, tabs], id: 'column');
      final DockingLayout layout = DockingLayout(root: column);
      expect(layout.findDockingTabsWithItem('a'), null);
      expect(layout.findDockingTabsWithItem('e'), tabs);
    });

    test('complex', () {
      final DockingItem itemA = dockingItem('a');
      final DockingItem itemB = dockingItem('b');
      final DockingItem itemC = dockingItem('c');
      final DockingItem itemD = dockingItem('d');
      final DockingItem itemE = dockingItem('e');
      final DockingColumn innerColumn =
          DockingColumn([itemB, itemC], id: 'innerColumn');
      final DockingRow row = DockingRow([itemA, innerColumn], id: 'row');
      final DockingTabs tabs = DockingTabs([itemD, itemE], id: 'tabs');
      final DockingColumn column = DockingColumn([row, tabs], id: 'column');
      final DockingLayout layout = DockingLayout(root: column);

      expect(layout.findDockingItem('a'), itemA);
      expect(layout.findDockingItem('b'), itemB);
      expect(layout.findDockingItem('c'), itemC);
      expect(layout.findDockingItem('d'), itemD);
      expect(layout.findDockingItem('e'), itemE);
      expect(layout.findDockingItem('f'), isNull);
      expect(layout.findDockingArea('innerColumn'), innerColumn);
      expect(layout.findDockingArea('row'), row);
      expect(layout.findDockingArea('column'), column);
      expect(layout.findDockingArea('innerColumn'), innerColumn);
    });

    test('complex 2', () {
      final DockingItem itemA = dockingItem('a');
      final DockingItem itemB = dockingItem('b');
      final DockingItem itemC = dockingItem('c');
      final DockingItem itemD = dockingItem('d');
      final DockingItem itemE = dockingItem('e');
      final DockingItem itemF = dockingItem('f');
      final DockingColumn innerColumn =
          DockingColumn([itemB, itemC], id: 'innerColumn');
      final DockingRow row = DockingRow([itemA, innerColumn], id: 'row');
      final DockingTabs tabs = DockingTabs([itemD, itemE], id: 'tabs');
      final DockingColumn column = DockingColumn([row, tabs, itemF], id: 'column');
      final DockingLayout layout = DockingLayout(root: column);

      expect(layout.findDockingItem('a'), itemA);
      expect(layout.findDockingItem('b'), itemB);
      expect(layout.findDockingItem('c'), itemC);
      expect(layout.findDockingItem('d'), itemD);
      expect(layout.findDockingItem('e'), itemE);
      expect(layout.findDockingItem('f'), itemF);
      expect(layout.findDockingItem('g'), isNull);
      expect(layout.findDockingArea('innerColumn'), innerColumn);
      expect(layout.findDockingArea('row'), row);
      expect(layout.findDockingArea('column'), column);
      expect(layout.findDockingArea('innerColumn'), innerColumn);
    });

    test('complex 3', () {
      final DockingItem itemA = dockingItem('a');
      final DockingItem itemB = dockingItem('b');
      final DockingItem itemC = dockingItem('c');
      final DockingItem itemD = dockingItem('d');
      final DockingItem itemE = dockingItem('e');
      final DockingItem itemF = dockingItem('f');
      final DockingItem itemG = dockingItem('g');
      final DockingColumn innerColumn =
          DockingColumn([itemB, itemC], id: 'innerColumn');
      final DockingRow row = DockingRow([itemA, innerColumn], id: 'row');
      final DockingTabs tabs = DockingTabs([itemD, itemE], id: 'tabs');
      final DockingColumn column = DockingColumn([row, tabs, itemF], id: 'column');
      final DockingRow row2 = DockingRow([itemG, column], id: 'row2');
      final DockingLayout layout = DockingLayout(root: row2);

      expect(layout.findDockingItem('a'), itemA);
      expect(layout.findDockingItem('b'), itemB);
      expect(layout.findDockingItem('c'), itemC);
      expect(layout.findDockingItem('d'), itemD);
      expect(layout.findDockingItem('e'), itemE);
      expect(layout.findDockingItem('f'), itemF);
      expect(layout.findDockingItem('g'), itemG);
      expect(layout.findDockingItem('h'), isNull);
      expect(layout.findDockingArea('innerColumn'), innerColumn);
      expect(layout.findDockingArea('row'), row);
      expect(layout.findDockingArea('row2'), row2);
      expect(layout.findDockingArea('column'), column);
      expect(layout.findDockingArea('innerColumn'), innerColumn);
    });
  });
}
