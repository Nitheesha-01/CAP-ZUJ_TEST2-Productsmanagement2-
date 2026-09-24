using ProductsMgmtService as service from '../../srv/products-srv';

annotate service.Products with @(
    UI.SelectionFields: [
        ID,
        name,
        price,
        stock,
    ],
    UI.LineItem       : [
        {
            $Type: 'UI.DataField',
            Value: ID,
        },
        {
            $Type: 'UI.DataField',
            Value: name,
        },
        {
            $Type: 'UI.DataField',
            Value: description,
            
        },
        {
            $Type: 'UI.DataField',
            Value: discount,
           
        },
        {
            $Type: 'UI.DataField',
            Value: price,
        },
        {
            $Type: 'UI.DataField',
            Value: stock,
        },
        {
            $Type : 'UI.DataField',
            Value : status,
            Label : 'status',
            Criticality : statusCriticality,
            CriticalityRepresentation : #WithIcon,
        },
        {
            $Type : 'UI.DataField',
            Value : discountedPrice,
            Label : 'discountedPrice',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'ProductsMgmtService.Addstock',
            Label : 'Add Stock',
        },
    ],
    UI.HeaderInfo : {
        TypeName : 'Product',
        TypeNamePlural : 'Products',
        Title : {
            $Type : 'UI.DataField',
            Value : name,
        },
        Description : {
            $Type : 'UI.DataField',
            Value : description,
        },
        ImageUrl : image,
    },
    UI.DataPoint #ID : {
        $Type : 'UI.DataPointType',
        Value : ID,
        Title : 'Product ID',
    },
    UI.DataPoint #price : {
        $Type : 'UI.DataPointType',
        Value : price,
        Title : 'Price',
    },
    UI.DataPoint #stock : {
        $Type : 'UI.DataPointType',
        Value : stock,
        Title : 'Stock',
    },
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'ID',
            Target : '@UI.DataPoint#ID',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'price',
            Target : '@UI.DataPoint#price',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'stock',
            Target : '@UI.DataPoint#stock',
        },
    ],
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Product Information',
            ID : 'ProductInformation',
            Target : '@UI.FieldGroup#ProductInformation',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Upload Product Image',
            ID : 'UploadProductImage',
            Target : '@UI.FieldGroup#UploadProductImage',
        },
    ],
    UI.FieldGroup #ProductInformation : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : ID,
            },
            {
                $Type : 'UI.DataField',
                Value : name,
            },
            {
                $Type : 'UI.DataField',
                Value : description,
            },
            {
                $Type : 'UI.DataField',
                Value : discount,
            },
            {
                $Type : 'UI.DataField',
                Value : price,
            },
            {
                $Type : 'UI.DataField',
                Value : stock,
            },
            {
                $Type : 'UI.DataField',
                Value : discountedPrice,
                Label : 'discountedPrice',
            },
        ],
    },
    UI.FieldGroup #UploadProductImage : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : image,
                Label : 'image',
            },
        ],
    },
);

annotate service.Products with {
    ID          @(
        Common.Label: 'Product ID',
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Products',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : ID,
                    ValueListProperty : 'ID',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name',
                },
            ],
            Label : 'Select Product ID',
        },
        Common.ValueListWithFixedValues : false,
    );
    name        @Common.Label: 'Product Name';
    description @Common.Label: 'Description';
    discount    @Common.Label: 'Discount';
    price       @Common.Label: 'Price';
    stock       @Common.Label: 'Stock'
};
