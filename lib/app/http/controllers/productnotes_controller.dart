import 'package:vania/vania.dart';
import 'package:pamldicka/app/models/products.dart'; 
import 'package:pamldicka/app/models/productnotes.dart'; 

class ProductnotesController extends Controller {
  Future<Response> index() async { 
    try { 
      var results = await ProductNotes() 
          .query() 
          .join('products', 'productnotes.prod_id', '=', 'products.prod_id') 
          .select(['productnotes.*', 'products.prod_name']).get(); 
       return Response.json({ 
        'success': true, 
        'message': 'Product Notes found', 
        'data': results, 
      }); 
    } catch (e) { 
      return Response.json({ 
        'success': false, 
        'message': 'Failed to get product notes', 
        'error': e.toString() 
      }); 
    } 
  } 
 
  Future<Response> create() async { 
    return Response.json({}); 
  } 

  Future<Response> store(Request request) async { 
    try { 
      var productId = request.input('product_id'); 
      var isProductExist = await Product().query().where('prod_id', '=', productId).first(); 
      if (isProductExist == null) { 
        return Response.json({ 
          'success': false, 
          'message': 'Product not found', 
        }); 
      } 
 
      var noteDate = request.input('date'); 
      var noteText = request.input('text'); 
 
      var productNoteId = ProductNotes().generateId(); 
      await ProductNotes().query().insert({ 
        'note_id': productNoteId, 
        'prod_id': isProductExist['prod_id'], 
        'note_date': noteDate, 
        'note_text': noteText, 
        'created_at': DateTime.now().toIso8601String(), 
        'updated_at': DateTime.now().toIso8601String(), 
      }); 

      var productNote = await ProductNotes() 
          .query() 
          .where('note_id', '=', productNoteId) 
          .first(); 
 
      return Response.json({ 
        'success': true, 
        'message': 'Product Note created successfully', 
        'data': productNote 
      }); 
    } catch (e) { 
      return Response.json({ 
        'success': false, 
        'message': 'Failed to create product note', 
        'error': e.toString() 
      }); 
    } 
  } 
 
  Future<Response> show(int id) async { 
    return Response.json({}); 
  } 
 
  Future<Response> edit(int id) async { 
    return Response.json({}); 
  } 
 
  Future<Response> update(Request request, String id) async 
{ 
    try { 
      var existingProductNote = await ProductNotes().query().where('note_id', '=', id).first(); 
      if (existingProductNote == null) { 
        return Response.json({ 
          'success': false, 
          'message': 'Product Note not found', 
        }); 
      } 
      var productId = request.input('product_id'); 
      if (productId != null && productId.isNotEmpty) { 
        var isProductExist = await Product().query().where('prod_id', '=', productId).first(); 
        if (isProductExist == null) { 
          return Response.json({ 
            'success': false, 
            'message': 'Product not found', 
          }); 
        } 
      } else { 
        productId = existingProductNote['prod_id']; 
      } 
 
      var noteDate = request.input('date'); 
      var noteText = request.input('text'); 
      await ProductNotes().query().where('note_id', '=', id).update({ 
        'prod_id': productId, 
        'note_date': noteDate, 
        'note_text': noteText, 
        'updated_at': DateTime.now().toIso8601String(), 
      }); 
 
      var productNote = await ProductNotes().query().where('note_id', '=', id).first(); 
 
      return Response.json({ 
        'success': true, 
        'message': 'Product Note updated successfully', 
        'data': productNote 
      }); 
    } catch (e) { 
      return Response.json({ 
        'success': false, 
        'message': 'Failed to update product note', 
        'error': e.toString() 
      }); 
    } 
  } 
 
  Future<Response> destroy(String id) async { 
    try { 
      var existingProductNote = await ProductNotes().query().where('note_id', '=', id).first(); 
      if (existingProductNote == null) { 
        return Response.json({ 
          'success': false, 
          'message': 'Product Note not found', 
        }); 
      } 
      await ProductNotes().query().where('note_id', '=', id).delete(); 
      return Response.json({ 
        'success': true, 
        'message': 'Product Note deleted successfully', 
      }); 
    } catch (e) { 
      return Response.json({ 
        'success': false, 
        'message': 'Failed to delete product note', 
        'error': e.toString() 
      }); 
    } 
  } 
} 

final ProductnotesController productnotesController = ProductnotesController();

