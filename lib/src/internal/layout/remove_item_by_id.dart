import 'package:docking/src/internal/layout/layout_modifier.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:meta/meta.dart';

/// Removes [DockingItem] by id from this layout.
@internal
class RemoveItemById extends LayoutModifier {
  RemoveItemById({required this.id});

  final dynamic id;

  @override
  DockingArea? newLayout(DockingLayout layout) {
    if (layout.root != null) {
      return _buildLayout(layout.root!);
    }
    return null;
  }

  /// Builds a new root.
  DockingArea? _buildLayout(DockingArea area) {
    if (area is DockingItem) {
      final DockingItem dockingItem = area;
      if (dockingItem.id == id) {
        return null;
      }
      return dockingItem;
    } else if (area is DockingTabs) {
      final DockingTabs dockingTabs = area;
      final List<DockingItem> children = [];
      dockingTabs.forEach((child) {
        if (child.id != id) {
          children.add(child);
        }
      });
      if (children.length == 1) {
        return children.first;
      }
      final DockingTabs newDockingTabs = DockingTabs(children,
          id: dockingTabs.id,
          maximized: dockingTabs.maximized,
          maximizable: dockingTabs.maximizable,);
      newDockingTabs.selectedIndex = dockingTabs.selectedIndex;
      return newDockingTabs;
    } else if (area is DockingParentArea) {
      final List<DockingArea> children = [];
      area.forEach((child) {
        final DockingArea? newChild = _buildLayout(child);
        if (newChild != null) {
          children.add(newChild);
        }
      });
      if (children.isEmpty) {
        return null;
      } else if (children.length == 1) {
        return children.first;
      }
      if (area is DockingRow) {
        return DockingRow(children, id: area.id);
      } else if (area is DockingColumn) {
        return DockingColumn(children, id: area.id);
      }
      throw ArgumentError(
          'DockingArea class not recognized: ${area.runtimeType}',);
    }
    throw ArgumentError(
        'DockingArea class not recognized: ${area.runtimeType}',);
  }
}
