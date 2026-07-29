namespace zuj_test2.db;

using {
        cuid,
        managed
} from '@sap/cds/common';


entity Products : cuid {
        name        : String(50)     @mandatory;
        description : String(100);
        price       : Decimal(10, 2) @mandatory;
        discount    : Integer        @assert.format : '^(?:[0-9]|[1-6][0-9]|70)$';
        stock       : Integer        @mandatory;
        image       : LargeBinary    @Core.MediaType: 'image/jpeg';

         discountedPrice     : Decimal(15,2) @Core.Computed;
}

entity Orders : cuid, managed {
        customerName   : String(30);
        customerMobile : String(10);
        storeName      : String(20);
        netPrice       : Decimal(15, 2);
        items          : Composition of many OrderItems
                                 on items.order = $self
}

entity OrderItems : cuid {
        order      : Association to Orders;
        product    : Association to Products;
        quantity   : Integer;
        unitPrice  : Decimal(15, 2);
        discount   : Integer;
        totalPrice : Decimal(15, 2);
}
