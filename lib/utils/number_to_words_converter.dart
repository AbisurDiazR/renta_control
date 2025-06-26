// lib/utils/number_to_words_converter.dart

// ignore_for_file: unused_element, unused_local_variable

// Diccionarios o listas de palabras base
const List<String> _unidades = [
  '', 'UN', 'DOS', 'TRES', 'CUATRO', 'CINCO', 'SEIS', 'SIETE', 'OCHO', 'NUEVE'
];
const List<String> _diezAVeinte = [
  'DIEZ', 'ONCE', 'DOCE', 'TRECE', 'CATORCE', 'QUINCE', 'DIECISÉIS', 'DIECISIETE', 'DIECIOCHO', 'DIECINUEVE'
];
const List<String> _decenas = [
  '', '', 'VEINTE', 'TREINTA', 'CUARENTA', 'CINCUENTA', 'SESENTA', 'SETENTA', 'OCHENTA', 'NOVENTA'
];
const List<String> _centenas = [
  '', 'CIENTO', 'DOSCIENTOS', 'TRESCIENTOS', 'CUATROCIENTOS', 'QUINIENTOS', 'SEISCIENTOS', 'SETECIENTOS', 'OCHOCIENTOS', 'NOVECIENTOS'
];

String _unidadesALetras(int num) {
  if (num >= 1 && num <= 9) {
    return _unidades[num];
  }
  return '';
}

String _decenasALetras(int num) {
  var decena = num ~/ 10; // División entera
  var unidad = num - (decena * 10);

  switch (decena) {
    case 1:
      return _diezAVeinte[unidad];
    case 2:
      return unidad == 0 ? 'VEINTE' : 'VEINTI${_unidadesALetras(unidad)}';
    case 3:
      return _decenasY('TREINTA', unidad);
    case 4:
      return _decenasY('CUARENTA', unidad);
    case 5:
      return _decenasY('CINCUENTA', unidad);
    case 6:
      return _decenasY('SESENTA', unidad);
    case 7:
      return _decenasY('SETENTA', unidad);
    case 8:
      return _decenasY('OCHENTA', unidad);
    case 9:
      return _decenasY('NOVENTA', unidad);
    case 0:
      return _unidadesALetras(unidad);
    default:
      return ''; // No debería pasar
  }
}

String _decenasY(String strSin, int numUnidades) {
  if (numUnidades > 0) {
    return '$strSin Y ${_unidadesALetras(numUnidades)}';
  }
  return strSin;
}

String _centenasALetras(int num) {
  var centenas = num ~/ 100; // División entera
  var decenas = num - (centenas * 100);

  switch (centenas) {
    case 1:
      if (decenas > 0) return 'CIENTO ${_decenasALetras(decenas)}';
      return 'CIEN';
    case 2:
      return 'DOSCIENTOS ${_decenasALetras(decenas)}';
    case 3:
      return 'TRESCIENTOS ${_decenasALetras(decenas)}';
    case 4:
      return 'CUATROCIENTOS ${_decenasALetras(decenas)}';
    case 5:
      return 'QUINIENTOS ${_decenasALetras(decenas)}';
    case 6:
      return 'SEISCIENTOS ${_decenasALetras(decenas)}';
    case 7:
      return 'SETECIENTOS ${_decenasALetras(decenas)}';
    case 8:
      return 'OCHOCIENTOS ${_decenasALetras(decenas)}';
    case 9:
      return 'NOVECIENTOS ${_decenasALetras(decenas)}';
    default:
      return _decenasALetras(decenas); // Si no hay centenas, procesa las decenas
  }
}

// Función para procesar secciones de miles y millones
String _seccion(int num, int divisor, String strSingular, String strPlural) {
  var cientos = num ~/ divisor; // División entera
  var letras = '';

  if (cientos > 0) {
    if (cientos > 1) {
      letras = '${_centenasALetras(cientos)} $strPlural';
    } else {
      letras = strSingular;
    }
  }
  return letras.trim(); // Eliminar espacios al inicio/final
}

String _milesALetras(int num) {
  const divisor = 1000;
  var cientos = num ~/ divisor;
  var resto = num - (cientos * divisor);

  var strMiles = _seccion(num, divisor, 'UN MIL', 'MIL');
  var strCentenas = _centenasALetras(resto);

  if (strMiles == '') {
    return strCentenas.trim();
  }
  if (resto == 0) {
      return strMiles.trim();
  }
  return '$strMiles $strCentenas'.trim();
}

String _millonesALetras(int num) {
  const divisor = 1000000;
  var cientos = num ~/ divisor;
  var resto = num - (cientos * divisor);

  var strMillones = _seccion(num, divisor, 'UN MILLÓN', 'MILLONES');
  
  String result = '';
  if (cientos == 1) {
    result = 'UN MILLÓN';
  } else if (cientos > 1) {
    result = '${_centenasALetras(cientos)} MILLONES';
  }

  if (resto > 0) {
    result = '$result ${_milesALetras(resto)}'; // Aquí debe llamar a milesALetras para el resto
  }

  return result.trim();
}


/// Función principal para convertir un número a letras, incluyendo parte monetaria.
/// Puedes ajustar los parámetros de moneda según tus necesidades.
String numeroAMonedaEnLetras(
  double num, {
  String letrasMonedaPlural = 'PESOS',
  String letrasMonedaSingular = 'PESO',
  String letrasMonedaCentavoPlural = 'CENTAVOS',
  String letrasMonedaCentavoSingular = 'CENTAVO',
}) {
  if (num == 0) {
    return 'CERO $letrasMonedaPlural 00/100 M.N.';
  }

  var enteros = num.floor();
  var centavos = ((num - enteros) * 100).round(); // Redondea para evitar errores de coma flotante

  var letrasCentavos = '';
  if (centavos > 0) {
    // Si los centavos son 1, usar singular
    if (centavos == 1) {
      letrasCentavos = 'CON ${_unidadesALetras(centavos)} $letrasMonedaCentavoSingular';
    } else {
      // Para centavos (0-99), _decenasALetras es apropiado
      letrasCentavos = 'CON ${_decenasALetras(centavos)} $letrasMonedaCentavoPlural';
    }
  }

  String resultadoEnteros;
  if (enteros == 0) {
    resultadoEnteros = 'CERO'; // Aunque el caso num==0 ya se manejó, para seguridad.
  } else if (enteros == 1) {
    resultadoEnteros = 'UN'; // Para "UN PESO"
  } else {
    resultadoEnteros = _millonesALetras(enteros);
  }

  // Ajustes finales para el formato de moneda
  String finalResult = '';
  if (enteros == 1) {
    finalResult = '$resultadoEnteros $letrasMonedaSingular';
  } else {
    finalResult = '$resultadoEnteros $letrasMonedaPlural';
  }

  // Si hay centavos, los añade.
  if (letrasCentavos.isNotEmpty) {
      finalResult = '$finalResult $letrasCentavos';
  }
  
  // Asegurar el formato final de centavos (ej. 00/100 M.N.)
  finalResult += ' ${centavos.toString().padLeft(2, '0')}/100 M.N.';

  return finalResult.trim().replaceAll(RegExp(r'\s+'), ' '); // Limpiar espacios extra
}