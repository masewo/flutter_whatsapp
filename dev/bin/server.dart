import 'dart:async' show Future;
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

final _headers = {
  HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
  'Access-Control-Allow-Origin': '*'
};

class Service {
  Handler get handler {
    final router = Router();

    router.mount('/api/', Api().router);

    router.all('/<ignored|.*>', (Request request) {
      return Response.notFound('Page not found');
    });

    return router;
  }
}

class Api {
  Router get router {
    final router = Router();

    router.all('/<ignored|.*>', _handler);

    return router;
  }

  Future<Response> _handler(Request request) async {
    var file = File('responses/${request.url}.json');
    if (file.existsSync()) {
      return Response.ok(file.readAsStringSync(), headers: _headers);
    } else {
      return Response.notFound('Page not found');
    }
  }
}

void main() async {
  final service = Service();
  final server = await shelf_io.serve(service.handler, 'localhost', 80);
  print('Server running on localhost:${server.port}');
}