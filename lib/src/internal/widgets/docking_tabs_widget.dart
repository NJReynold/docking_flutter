import 'dart:math' as math;

import 'package:docking/src/docking_buttons_builder.dart';
import 'package:docking/src/drag_over_position.dart';
import 'package:docking/src/internal/widgets/draggable_config_mixin.dart';
import 'package:docking/src/internal/widgets/drop/drop_feedback_widget.dart';
import 'package:docking/src/layout/docking_layout.dart';
import 'package:docking/src/layout/drop_position.dart';
import 'package:docking/src/on_item_close.dart';
import 'package:docking/src/on_item_selection.dart';
import 'package:docking/src/theme/docking_theme.dart';
import 'package:docking/src/theme/docking_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tabbed_view/tabbed_view.dart';

/// Represents a widget for [DockingTabs].
class DockingTabsWidget extends StatefulWidget {
  const DockingTabsWidget({
    required this.layout, required this.dragOverPosition, required this.dockingTabs, required this.maximizableTab, required this.maximizableTabsArea, required this.draggable, Key? key,
    this.onItemSelection,
    this.onItemClose,
    this.itemCloseInterceptor,
    this.dockingButtonsBuilder,
    this.viewBuilder,
    this.onBeforeDropAccept,
    this.onDraggableBuild,
    this.tabReorderEnabled = true,
    this.onTabSecondaryTap,
    this.unselectedTabButtonsBehavior,
    this.contentClip,
    this.closeButtonTooltip,
    this.tabsAreaButtonsBuilder,
    this.tabsAreaVisible,
    this.canDrop,
    this.dragScope,
    this.tabRemoveInterceptor,
    this.trailing,
  }) : super(key: key);

  final DockingLayout layout;
  final DockingTabs dockingTabs;
  final OnItemSelection? onItemSelection;
  final OnItemClose? onItemClose;
  final ItemCloseInterceptor? itemCloseInterceptor;
  final DockingButtonsBuilder? dockingButtonsBuilder;
  final bool maximizableTab;
  final bool maximizableTabsArea;
  final DragOverPosition dragOverPosition;
  final bool draggable;

  final TabViewBuilder? viewBuilder;
  final OnDraggableBuild? onDraggableBuild;
  final OnBeforeDropAccept? onBeforeDropAccept;
  final bool tabReorderEnabled;
  final OnTabSecondaryTap? onTabSecondaryTap;
  final UnselectedTabButtonsBehavior? unselectedTabButtonsBehavior;
  final bool? contentClip;
  final String? closeButtonTooltip;
  final TabsAreaButtonsBuilder? tabsAreaButtonsBuilder;
  final bool? tabsAreaVisible;
  final CanDrop? canDrop;
  final String? dragScope;
  final TabRemoveInterceptor? tabRemoveInterceptor;
  final Widget? trailing;

  @override
  State<StatefulWidget> createState() => DockingTabsWidgetState();
}

class DockingTabsWidgetState extends State<DockingTabsWidget> with DraggableConfigMixin {
  DropPosition? _activeDropPosition;

  @override
  Widget build(BuildContext context) {
    final List<TabData> tabs = [];
    widget.dockingTabs.forEach((child) {
      Widget content = child.builder!(context, child);
      if (child.globalKey != null) {
        content = KeyedSubtree(key: child.globalKey, child: content);
      }
      List<TabButton>? buttons;
      if (child.buttons != null && child.buttons!.isNotEmpty) {
        buttons = [];
        buttons.addAll(child.buttons!);
      }
      final bool maximizable = child.maximizable != null ? child.maximizable! : widget.maximizableTab;
      if (maximizable) {
        buttons ??= [];
        final DockingThemeData data = DockingTheme.of(context);
        if (widget.layout.maximizedArea != null && widget.layout.maximizedArea == child) {
          buttons.add(TabButton(icon: data.restoreIcon, onPressed: () => widget.layout.restore()));
        } else {
          buttons.add(TabButton(icon: data.maximizeIcon, onPressed: () => widget.layout.maximizeDockingItem(child)));
        }
      }
      tabs.add(TabData(
          value: child,
          text: child.name != null ? child.name! : '',
          view: content,
          closable: child.closable,
          keepAlive: child.globalKey != null,
          leading: child.leading,
          buttonsBuilder: (context) => buttons ?? [],
          draggable: widget.draggable,),);
    });
    final TabbedViewController controller = TabbedViewController(tabs);
    controller.selectedIndex = math.min(widget.dockingTabs.selectedIndex, tabs.length - 1);

    final Widget tabbedView = TabbedView(
        controller: controller,
        viewBuilder: widget.viewBuilder ?? _viewBuilder,
        //onTabSelection: onTabSelection,
        //tabCloseInterceptor: _tabCloseInterceptor,
        //onTabClose: _onTabClose,
        onDraggableBuild: widget.onDraggableBuild,
        /* onDraggableBuild: widget.draggable
            ? (TabbedViewController controller, int tabIndex, TabData tabData) {
                return buildDraggableConfig(
                    dockingDrag: widget.dragOverPosition, tabData: tabData);
              }
            : null, */
        tabReorderEnabled: widget.tabReorderEnabled,
        onTabSecondaryTap: widget.onTabSecondaryTap,
        unselectedTabButtonsBehavior: widget.unselectedTabButtonsBehavior,
        contentClip: widget.contentClip,
        closeButtonTooltip: widget.closeButtonTooltip,
        tabsAreaButtonsBuilder: widget.tabsAreaButtonsBuilder,
        tabsAreaVisible: widget.tabsAreaVisible,
        canDrop: widget.canDrop,
        dragScope: widget.dragScope,
        tabRemoveInterceptor: widget.tabRemoveInterceptor,
        trailing: widget.trailing,);
    /* Widget tabbedView = TabbedView(
        controller: controller,
        tabsAreaButtonsBuilder: _tabsAreaButtonsBuilder,
        onTabSelection: (int? index) {
          if (index != null) {
            widget.dockingTabs.selectedIndex = index;
            if (widget.onItemSelection != null) {
              widget.onItemSelection!(widget.dockingTabs.childAt(index));
            }
          }
        },
        tabCloseInterceptor: _tabCloseInterceptor,
        onDraggableBuild: widget.draggable
            ? (TabbedViewController controller, int tabIndex, TabData tabData) {
                return buildDraggableConfig(
                    dockingDrag: widget.dragOverPosition, tabData: tabData);
              }
            : null,
        onTabClose: _onTabClose,
        contentBuilder: (context, tabIndex) => TabsContentWrapper(
            listener: _updateActiveDropPosition,
            layout: widget.layout,
            dockingTabs: widget.dockingTabs,
            child: controller.tabs[tabIndex].content!),
        onBeforeDropAccept: widget.draggable ? _onBeforeDropAccept : null); */
    if (widget.draggable && widget.dragOverPosition.enable) {
      return DropFeedbackWidget(dropPosition: _activeDropPosition, child: tabbedView);
    }
    return tabbedView;
  }

  Widget _viewBuilder(BuildContext context, TabData tab) {
    return const SizedBox.shrink();
  }

  void _updateActiveDropPosition(DropPosition? dropPosition) {
    if (_activeDropPosition != dropPosition) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _activeDropPosition = dropPosition;
          });
        }
      });
    }
  }

  bool _onBeforeDropAccept(DraggableTabData source, int newIndex) {
    final DockingItem dockingItem = source.tab.value! as DockingItem;
    widget.layout.moveItem(draggedItem: dockingItem, targetArea: widget.dockingTabs, dropIndex: newIndex);
    return true;
  }

  List<TabButton> _tabsAreaButtonsBuilder(BuildContext context, int tabsCount) {
    final List<TabButton> buttons = [];
    if (widget.dockingButtonsBuilder != null) {
      buttons.addAll(widget.dockingButtonsBuilder!(context, widget.dockingTabs, null));
    }
    final bool maximizable = widget.dockingTabs.maximizable != null ? widget.dockingTabs.maximizable! : widget.maximizableTabsArea;
    if (maximizable) {
      final DockingThemeData data = DockingTheme.of(context);
      if (widget.layout.maximizedArea != null && widget.layout.maximizedArea == widget.dockingTabs) {
        buttons.add(TabButton(icon: data.restoreIcon, onPressed: () => widget.layout.restore()));
      } else {
        buttons.add(TabButton(icon: data.maximizeIcon, onPressed: () => widget.layout.maximizeDockingTabs(widget.dockingTabs)));
      }
    }
    return buttons;
  }

  bool _tabCloseInterceptor(int tabIndex) {
    if (widget.itemCloseInterceptor != null) {
      return widget.itemCloseInterceptor!(widget.dockingTabs.childAt(tabIndex));
    }
    return true;
  }

  void _onTabClose(int tabIndex, TabData tabData) {
    final DockingItem dockingItem = widget.dockingTabs.childAt(tabIndex);
    widget.layout.removeItem(item: dockingItem);
    if (widget.onItemClose != null) {
      widget.onItemClose!(dockingItem);
    }
  }
}
