Feature: /pedidos/folio/busquedas POST

      Consulta detalles del pedido

      Scenario: Negocio un consumer key y secret key de la app de prueba
            Given I have basic authentication credentials `apigeeUsername` and `apigeePassword`
            And I have valid client TLS configuration
            When I GET `apigeeHost`/v1/organizations/`apigeeOrg`/developers/`apigeeDeveloper`/apps/`apigeeApp`
            Then response code should be 200
            And response body should be valid json
            And I store the value of body path $.credentials[*].consumerKey as globalConsumerKey in global scope
            And I store the value of body path $.credentials[*].consumerSecret as globalConsumerSecret in global scope

      Scenario: Negocia un access token con el Authorization server
            Given I set form parameters to
                  | parameter  | value              |
                  | grant_type | client_credentials |
            And I have basic authentication credentials `globalConsumerKey` and `globalConsumerSecret`
            And I have valid client TLS configuration
            When I POST to `apigeeDomain`/`apigeeOauthEndpoint`
            Then response code should be 200
            And response body should be valid json
            And I store the value of body path $.access_token as access token

      Scenario: Genera token y llaves asimétricas
            Given I set bearer token
            And I have valid client TLS configuration
            And I set x-ismock header to true
            When I GET `apigeeDomain`/elektra/seguridad/`deploymentSuffix`/aplicaciones/llaves
            Then response code should be 200
            And response body should be valid json
            And I store the value of body path $.resultado.idAcceso as idAccess in global scope
            And I store the value of body path $.resultado.accesoPrivado as privateKey in global scope
            And I store the value of body path $.resultado.accesoPublico as publicKey in global scope

      Scenario Outline: 200 ok.
            Verificar que se obtenga la información relacionada desde una transacción POST en /pedidos/folio/busquedas
            Given I set bearer token
            And I set Content-Type header to application/json            
            And I have valid client TLS configuration
            And I set x-idPais header to <x-idPais>
            And I set x-idCanal header to <x-idCanal>
            And I set x-idSucursal header to <x-idSucursal>
            And I set x-idAcceso header to `idAccess`
            And I need to encrypt the parameters {idUsuario, clienteUnico}
            And I use the encryption algorithm RSA_PKCS1_PADDING and the key publicKey for prepare a body as {"idUsuario":"<idUsuario>","clienteUnico":"<clienteUnico>","fechaHoraInicio":"<fechaHoraInicio>","fechaHoraFin":"<fechaHoraFin>"}
            When I POST to `apigeeDomain`/elektra/comercio/pedidos-productos/`deploymentSuffix`/pedidos/<folio>/busquedas
            Then response code should be 200
            And response body should be valid json
            And response body path $.codigo should be ^200\.Elektra-Comercio-Pedidos-Productos\.\d{6}$
            And response body path $.mensaje should be ^.*$
            And response body path $.folio should be ^114-\d{15,22}$
            And response body path $.resultado.pedidos[*].folio should be [a-z0-9]*
            And response body path $.resultado.pedidos[*].idPais should be \d*
            And response body path $.resultado.pedidos[*].idCanal should be \d*
            And response body path $.resultado.pedidos[*].idSucursal should be \d*
            And response body path $.resultado.pedidos[*].idTipoVenta should be \d*
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].totalVenta and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And response body path $.resultado.pedidos[*].totalDescuento should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].idEstatusFolio should be \d*
            And response body path $.resultado.pedidos[*].descripcionEstatusFolio should be ^.*$
            And response body path $.resultado.pedidos[*].inventariable should be [a-z]*
            And response body path $.resultado.pedidos[*].foliosReferencia[*].id should be ^.*$
            And response body path $.resultado.pedidos[*].foliosReferencia[*].idTipo should be \d*
            And response body path $.resultado.pedidos[*].productos[*].sku should be \d*
            And response body path $.resultado.pedidos[*].productos[*].idPartida should be \d*
            And response body path $.resultado.pedidos[*].productos[*].tipo should be ^.*$
            And response body path $.resultado.pedidos[*].productos[*].descripcion should be ^.*$
            And response body path $.resultado.pedidos[*].productos[*].cantidad should be \d*
            And response body path $.resultado.pedidos[*].productos[*].precioLista should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].descuentoUnitario should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].precioVenta should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].precioTotal should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].series[*] should be SDKS12123123
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].productos[*].prepago.identificadorInternacional and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].productos[*].prepago.identificadorCarga and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And response body path $.resultado.pedidos[*].productos[*].prepago.proveedorRed should be Telcel
            And response body path $.resultado.pedidos[*].productos[*].precioCredito.enganche should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].precioCredito.sobrePrecio should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].precioCredito.precio should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].precioCredito.total should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].precioCredito.abono.puntual should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].precioCredito.abono.normal should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].precioCredito.abono.ultimo should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].precioCredito.abono.digital should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].milenia.sku should be \d*
            And response body path $.resultado.pedidos[*].productos[*].milenia.tipo should be ^.*$
            And response body path $.resultado.pedidos[*].productos[*].milenia.descripcion should be ^.*$
            And response body path $.resultado.pedidos[*].productos[*].milenia.tiempoCobertura should be ^.*$
            And response body path $.resultado.pedidos[*].productos[*].milenia.precioLista should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].milenia.cantidad should be \d*
            And response body path $.resultado.pedidos[*].productos[*].milenia.descuento should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].milenia.precioVenta should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].milenia.series[*] should be [a-zA-Z0-9]*
            And response body path $.resultado.pedidos[*].productos[*].milenia.precioCredito.enganche should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].milenia.precioCredito.sobrePrecio should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].milenia.precioCredito.precio should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].milenia.precioCredito.total should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].milenia.precioCredito.abono.puntual should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].milenia.precioCredito.abono.normal should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].milenia.precioCredito.abono.ultimo should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].milenia.precioCredito.abono.digital should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].productos[*].regalo.idPromocion should be \d*
            And response body path $.resultado.pedidos[*].productos[*].regalo.cantidad should be \d*
            And response body path $.resultado.pedidos[*].productos[*].regalo.productos[*].sku should be \d*
            And response body path $.resultado.pedidos[*].productos[*].regalo.productos[*].descripcion should be ^.*$
            And response body path $.resultado.pedidos[*].productos[*].regalo.productos[*].cantidad should be \d*
            And response body path $.resultado.pedidos[*].productos[*].promociones[*].id should be \d*
            And response body path $.resultado.pedidos[*].productos[*].promociones[*].idTipo should be \d*
            And response body path $.resultado.pedidos[*].productos[*].promociones[*].idSubTipo should be \d*
            And response body path $.resultado.pedidos[*].productos[*].promociones[*].idRegalo should be \d*
            And response body path $.resultado.pedidos[*].productos[*].promociones[*].cantidad should be \d*
            And response body path $.resultado.pedidos[*].productos[*].promociones[*].montoOtorgado should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].seguros[*].sku should be \d*
            And response body path $.resultado.pedidos[*].seguros[*].descripcion should be ^.*$
            And response body path $.resultado.pedidos[*].seguros[*].precioLista should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].seguros[*].precioCredito.enganche should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].seguros[*].precioCredito.sobrePrecio should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].seguros[*].precioCredito.precio should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].seguros[*].precioCredito.total should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].seguros[*].precioCredito.abono.puntual should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].seguros[*].precioCredito.abono.normal should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].seguros[*].precioCredito.abono.ultimo should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].seguros[*].precioCredito.abono.digital should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].promociones[*].id should be \d*
            And response body path $.resultado.pedidos[*].promociones[*].idTipo should be \d*
            And response body path $.resultado.pedidos[*].promociones[*].idSubTipo should be \d*
            And response body path $.resultado.pedidos[*].promociones[*].idRegalo should be \d*
            And response body path $.resultado.pedidos[*].promociones[*].cantidad should be \d*
            And response body path $.resultado.pedidos[*].promociones[*].montoOtorgado should be ^[0-9]+([.][0-9]+)?$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].cliente.unico and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].cliente.elektra and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].ventaEmpleado.numeroEmpleado and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And response body path $.resultado.pedidos[*].ventaEmpleado.idNegocio should be \d*
            And response body path $.resultado.pedidos[*].credito.idPeriodo should be \d*
            And response body path $.resultado.pedidos[*].credito.idPlazo should be \d*
            And response body path $.resultado.pedidos[*].credito.enganche should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].credito.abono.puntual should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].credito.abono.normal should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].credito.abono.ultimo should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].credito.abono.digital should be ^[0-9]+([.][0-9]+)?$
            And response body path $.resultado.pedidos[*].datosEntrega.tipo should be ^.*$
            And response body path $.resultado.pedidos[*].datosEntrega.costo should be ^[0-9]+([.][0-9]+)?$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].datosEntrega.domicilio.codigoPostal and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].datosEntrega.domicilio.estado and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].datosEntrega.domicilio.municipio and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].datosEntrega.domicilio.colonia and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].datosEntrega.domicilio.calle and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].datosEntrega.domicilio.numeroExterior and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].datosEntrega.domicilio.numeroInterior and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].datosEntrega.domicilio.latitud and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].datosEntrega.domicilio.longitud and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And response body path $.resultado.pedidos[*].datosEntrega.domicilio.comentarios should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].datosEntrega.domicilio.referencias[*].referencia and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And response body path $.resultado.pedidos[*].datosEntrega.notaEntrega.titulo should be ^.*$
            And response body path $.resultado.pedidos[*].datosEntrega.notaEntrega.nota should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].datosEntrega.personaRecibe.nombre and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].datosEntrega.personaRecibe.correo and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].datosEntrega.personaRecibe.telefono and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].datosEntrega.personaNotifica.nombre and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].datosEntrega.personaNotifica.correo and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$
            And deciphering with the key privateKey the response field $.resultado.pedidos[*].datosEntrega.personaNotifica.telefono and RSA_PKCS1_PADDING as encryption algorithm should be ^.*$

            Examples:
                  | x-idPais | x-idCanal | x-idSucursal | folio  | idUsuario | clienteUnico    | fechaHoraInicio  | fechaHoraFin     |
                  | 1        | 1         | 100          | 146625 | T146363   | 1-1-4624-9705-1 | 2021-01-30 08:00 | 2021-01-31 23:00 |
                  | 1        | 1         | 100          | 146625 | T146363   | null            | 2021-01-30 08:00 | 2021-01-31 23:00 |
                  | 1        | 1         | 100          | 146625 | T146363   | 1-1-4624-9705-1 | null             | 2021-01-31 23:00 |
                  | 1        | 1         | 100          | 146625 | T146363   | 1-1-4624-9705-1 | 2021-01-30 08:00 | null             |


      Scenario Outline: 400 Entrada Incorrecta
            Verificar que se obtenga una salida incorrecta al enviar una petición malformada desde una transacción POST en /pedidos/folio/busquedas
            Given I set bearer token
            And I set Content-Type header to application/json
            And I have valid client TLS configuration
            And I set x-idPais header to <x-idPais>
            And I set x-idCanal header to <x-idCanal>
            And I set x-idSucursal header to <x-idSucursal>
            And I set x-idAcceso header to `idAccess`
            And I need to encrypt the parameters {idUsuario, clienteUnico}
            And I use the encryption algorithm RSA_PKCS1_PADDING and the key publicKey for prepare a body as {"idUsuario":"<idUsuario>","clienteUnico":"<clienteUnico>","fechaHoraInicio":"<fechaHoraInicio>","fechaHoraFin":"<fechaHoraFin>"}
            When I POST to `apigeeDomain`/elektra/comercio/pedidos-productos/`deploymentSuffix`/pedidos/<folio>/busquedas
            Then response code should be 400
            And response body should be valid json
            And response body path $.codigo should be ^400\.Elektra-Comercio-Pedidos-Productos\.\d{6}$
            And response body path $.mensaje should be ^.*$
            And response body path $.folio should be ^114-\d{15,22}$
            And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx/info#400\.Elektra-Comercio-Pedidos-Productos\.\d{3,6}$

            Examples:
                  | x-idPais | x-idCanal | x-idSucursal | folio  | idUsuario | clienteUnico    | fechaHoraInicio  | fechaHoraFin     |
                  | null     | 1         | 100          | 146625 | T146363   | 1-1-4624-9705-1 | 2021-01-30 08:00 | 2021-01-31 23:00 |
                  | 1        | null      | 100          | 146625 | T146363   | 1-1-4624-9705-1 | 2021-01-30 08:00 | 2021-01-31 23:00 |
                  | 1        | 1         | null         | 146625 | T146363   | 1-1-4624-9705-1 | 2021-01-30 08:00 | 2021-01-31 23:00 |
                  | 1        | 1         | 100          | null   | T146363   | 1-1-4624-9705-1 | 2021-01-30 08:00 | 2021-01-31 23:00 |
                  | 1        | 1         | 100          | 146625 | null      | 1-1-4624-9705-1 | 2021-01-30 08:00 | 2021-01-31 23:00 |


      Scenario Outline:  401 No autorizado
            Verificar que se obtenga una salida de acceso no autorizado desde una transacción POST en /pedidos/folio/busquedas
            Given I set bearer token
            And I set Content-Type header to application/json
            And I have valid client TLS configuration
            And I set x-idPais header to <x-idPais>
            And I set x-idCanal header to <x-idCanal>
            And I set x-idSucursal header to <x-idSucursal>
            And I set x-idAcceso header to `idAccess`
            And I need to encrypt the parameters {idUsuario, clienteUnico}
            And I use the encryption algorithm RSA_PKCS1_PADDING and the key publicKey for prepare a body as {"idUsuario":"<idUsuario>","clienteUnico":"<clienteUnico>","fechaHoraInicio":"<fechaHoraInicio>","fechaHoraFin":"<fechaHoraFin>"}
            When I POST to `apigeeDomain`/elektra/comercio/pedidos-productos/`deploymentSuffix`/pedidos/<folio>/busquedas
            Then response code should be 401
            And response body should be valid json
            And response body path $.codigo should be ^401\.Elektra-Comercio-Pedidos-Productos\.\d{6}$
            And response body path $.mensaje should be ^.*$
            And response body path $.folio should be ^114-\d{15,22}$
            And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx/info#401\.Elektra-Comercio-Pedidos-Productos\.\d{3,6}$

            Examples:
                  | x-idPais | x-idCanal | x-idSucursal | folio     | idUsuario | clienteUnico    | fechaHoraInicio  | fechaHoraFin     |
                  | 1        | 1         | 100          | 401146625 | T146363   | 1-1-4624-9705-1 | 2021-01-30 08:00 | 2021-01-31 23:00 |


      Scenario Outline: 404 No encontrado
            Verificar que se obtenga una salida incorrecta de recurso no encontrado al enviar datos no registrados desde una transacción POST en /pedidos/folio/busquedas
            Given I set bearer token
            And I set Content-Type header to application/json
            And I have valid client TLS configuration
            And I set x-idPais header to <x-idPais>
            And I set x-idCanal header to <x-idCanal>
            And I set x-idSucursal header to <x-idSucursal>
            And I set x-idAcceso header to `idAccess`
            And I need to encrypt the parameters {idUsuario, clienteUnico}
            And I use the encryption algorithm RSA_PKCS1_PADDING and the key publicKey for prepare a body as {"idUsuario":"<idUsuario>","clienteUnico":"<clienteUnico>","fechaHoraInicio":"<fechaHoraInicio>","fechaHoraFin":"<fechaHoraFin>"}
            When I POST to `apigeeDomain`/elektra/comercio/pedidos-productos/`deploymentSuffix`/pedidos/<folio>/busquedas
            Then response code should be 404
            And response body should be valid json
            And response body path $.codigo should be ^404\.Elektra-Comercio-Pedidos-Productos\.\d{6}$
            And response body path $.mensaje should be ^.*$
            And response body path $.folio should be ^114-\d{15,22}$
            And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx/info#404\.Elektra-Comercio-Pedidos-Productos\.\d{3,6}$

	      Examples:
                  |x-idPais	|x-idCanal	|x-idSucursal	|folio	|idUsuario	|clienteUnico	  |fechaHoraInicio	|fechaHoraFin|
                  |1          |1	      |100		      |404146625	|T146363	|1-1-4624-9705-1	  |2021-01-30 08:00	|2021-01-31 23:00|
                  |1	      |1	      |100		      |146625	|404T146363	|1-1-4624-9705-1	  |2021-01-30 08:00	|2021-01-31 23:00|
                  |1	      |1	      |100		      |146625	|T146363	|4041-1-4624-9705-1 |2021-01-30 08:00	|2021-01-31 23:00|



      Scenario Outline:  500 Operacion Inesperada
            Verificar que se obtenga un error inesperado desde una transacción POST en /pedidos/folio/busquedas
            Given I set bearer token
            And I set Content-Type header to application/json
            And I have valid client TLS configuration
            And I set x-ismock header to true
            And I set x-idPais header to <x-idPais>
            And I set x-idCanal header to <x-idCanal>
            And I set x-idSucursal header to <x-idSucursal>
            And I set x-idAcceso header to `idAccess`
            And I need to encrypt the parameters {idUsuario, clienteUnico}
            And I use the encryption algorithm RSA_PKCS1_PADDING and the key publicKey for prepare a body as {"idUsuario":"<idUsuario>","clienteUnico":"<clienteUnico>","fechaHoraInicio":"<fechaHoraInicio>","fechaHoraFin":"<fechaHoraFin>"}
            When I POST to `apigeeDomain`/elektra/comercio/pedidos-productos/`deploymentSuffix`/pedidos/<folio>/busquedas
            Then response code should be 500
            And response body should be valid json
            And response body path $.codigo should be ^500\.Elektra-Comercio-Pedidos-Productos\.\d{6}$
            And response body path $.mensaje should be ^.*$
            And response body path $.folio should be ^114-\d{15,22}$
            And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx/info#500\.Elektra-Comercio-Pedidos-Productos\.\d{3,6}$

            Examples:
                  | x-idPais | x-idCanal | x-idSucursal | folio     | idUsuario | clienteUnico    | fechaHoraInicio  | fechaHoraFin     |
                  | sa       | 1         | 100          | 500146625 | T146363   | 1-1-4624-9705-1 | 2021-01-30 08:00 | 2021-01-31 23:00 |

