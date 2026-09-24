using {zuj_test2.db as db} from '../db/schema';

service ProductsMgmtService {

    @odata.draft.enabled
    entity Products as
        projection on db.Products {
            *,
            case
                when stock = 0
                     then 'Out of stock'
                when stock < 20
                     then 'Low stock'
                else 'In stock'
            end as status : String(20),
            case
                when stock = 0
                     then '1'
                when stock < 20
                     then '2'
                else '3'
            end as statusCriticality : String
        }

        // entity Orders as projection on db.Orders ;
        // entity OrderItems as projection on db.OrderItems ;
        actions{
            Action Addstock(stock:Integer @Common.Label:'Add Stock') returns String;
        }
}
