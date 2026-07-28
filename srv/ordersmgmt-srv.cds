using {zuj_test2.db as db} from '../db/schema';

service OrderMgmtService {

    @odata.draft.enabled
    entity Orders     as projection on db.Orders;

    entity OrderItems as projection on db.OrderItems;
    entity Products   as projection on db.Products;
}
