using {zuj_test2.db as db} from '../db/schema';

service OrderMgmtService {

    @odata.draft.enabled
    @Common.SideEffects:{SourceEntities:['items'],TargetProperties:['netPrice']}
    entity Orders     as projection on db.Orders;
@Common.SideEffects:{SourceProperties:['unitPrice', 'quantity'],TargetProperties:['totalPrice']}
    entity OrderItems as projection on db.OrderItems;
    entity Products   as projection on db.Products;
}
