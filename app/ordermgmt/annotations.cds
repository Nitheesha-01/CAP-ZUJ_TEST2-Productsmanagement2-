using OrderMgmtService as service from '../../srv/ordersmgmt-srv';

annotate service.Orders with @(
    UI.SelectionFields         : [
        ID,
        netPrice,
        storeName,
    ],
    UI.LineItem                : [
        {
            $Type: 'UI.DataField',
            Value: ID,
        },
        {
            $Type: 'UI.DataField',
            Value: customerName,
            Label: 'Customer Name',
        },
        {
            $Type: 'UI.DataField',
            Value: customerMobile,
            Label: 'Customer Mobile',
        },
        {
            $Type: 'UI.DataField',
            Value: storeName,
        },
        {
            $Type: 'UI.DataField',
            Value: netPrice,
        },
        {
            $Type: 'UI.DataField',
            Value: createdBy,
        },
    ],
    UI.HeaderInfo              : {
        TypeName      : 'Order',
        TypeNamePlural: 'Orders',
        Title         : {
            $Type: 'UI.DataField',
            Value: ID,
        },
        TypeImageUrl  : 'sap-icon://my-sales-order',
    },
    UI.DataPoint #storeName    : {
        $Type: 'UI.DataPointType',
        Value: storeName,
        Title: 'Store Name',
    },
    UI.DataPoint #customerName : {
        $Type: 'UI.DataPointType',
        Value: customerName,
        Title: 'Customer Name',
    },
    UI.DataPoint #createdBy    : {
        $Type: 'UI.DataPointType',
        Value: createdBy,
        Title: 'Created By',
    },
    UI.HeaderFacets            : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'storeName',
            Target: '@UI.DataPoint#storeName',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'customerName',
            Target: '@UI.DataPoint#customerName',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'createdBy',
            Target: '@UI.DataPoint#createdBy',
        },
    ],
    UI.Facets                  : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Order Details',
            ID    : 'OrderDetails',
            Target: '@UI.FieldGroup#OrderDetails',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Order Items',
            ID    : 'OrderItems',
            Target: 'items/@UI.LineItem#OrderItems',
        },
    ],
    UI.FieldGroup #OrderDetails: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: ID,
            },
            {
                $Type: 'UI.DataField',
                Value: customerName,
                Label: 'customerName',
            },
            {
                $Type: 'UI.DataField',
                Value: customerMobile,
                Label: 'customerMobile',
            },
            {
                $Type: 'UI.DataField',
                Value: storeName,
            },
            {
                $Type: 'UI.DataField',
                Value: netPrice,
            },
        ],
    },
);

annotate service.Orders with {
    ID        @(
        Common.Label                   : 'Order ID',
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Orders',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'customerName',
                },
            ],
            Label         : 'Select Order',
        },
        Common.ValueListWithFixedValues: false,
    );
    netPrice  @Common.Label: 'Net Price';
    storeName @Common.Label: 'Store Name'
};


annotate service.OrderItems with @(UI.LineItem #OrderItems: [
    {
        $Type: 'UI.DataField',
        Value: ID,
        Label: 'Order Items ID',
    },
    {
        $Type: 'UI.DataField',
        Value: order_ID,
        Label: 'Order ID',
    },
    {
        $Type: 'UI.DataField',
        Value: product_ID,
        Label: 'Product ID',
    },
    {
        $Type: 'UI.DataField',
        Value: quantity,
        Label: 'Quantity',
    },
    {
        $Type: 'UI.DataField',
        Value: unitPrice,
        Label: 'Unit Price',
    },
    {
        $Type: 'UI.DataField',
        Value: discount,
        Label: 'Discount',
    },
    {
        $Type: 'UI.DataField',
        Value: totalPrice,
        Label: 'Total Price',
    },
]);

annotate service.OrderItems with {
    product @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Products',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: product_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    ValueListProperty: 'price',
                    LocalDataProperty: unitPrice,
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    ValueListProperty: 'discount',
                    LocalDataProperty: discount,
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'stock',
                },
            ],
            Label         : 'Select Product',
        },
        Common.ValueListWithFixedValues: false,
    )
};

annotate service.Products with {

    ID          @Common.Label: 'Product ID';
    name        @Common.Label: 'Product Name';
    description @Common.Label: 'Description';
    discount    @Common.Label: 'Discount';
    price       @Common.Label: 'Price';
    stock       @Common.Label: 'Stock'
}
