/**
 * @description Provides pick-list options for the Hero Details component position (Left/Right) within Visual Editor.
 */
global class HeroDetailsPositionCustomPicklist extends VisualEditor.DynamicPickList {
    /**
     * @description Returns the default pick-list value (Right).
     */
    global override VisualEditor.DataRow getDefaultValue() {
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(
            'Right',
            'right'
        );
        return defaultValue;
    }
    /**
     * @description Returns all available pick-list values for the position selector.
     */
    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DataRow value1 = new VisualEditor.DataRow('Left', 'left');
        VisualEditor.DataRow value2 = new VisualEditor.DataRow(
            'Right',
            'right'
        );
        VisualEditor.DynamicPickListRows myValues = new VisualEditor.DynamicPickListRows();
        myValues.addRow(value1);
        myValues.addRow(value2);
        return myValues;
    }
}
