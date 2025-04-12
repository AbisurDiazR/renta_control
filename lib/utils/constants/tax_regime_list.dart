import 'package:renta_control/domain/models/invoice/tax_regime.dart';

List<TaxRegime> taxRegimesList = [
  TaxRegime(key: '601', description: 'General de Ley Personas Morales'),
  TaxRegime(
    key: '603',
    description: 'Personas Morales con Fines no Lucrativos',
  ),
  TaxRegime(
    key: '605',
    description: 'Sueldos y Salarios e Ingresos Asimilados a Salarios',
  ),
  TaxRegime(key: '606', description: 'Arrendamiento'),
  TaxRegime(
    key: '607',
    description: 'Régimen de Enajenación o Adquisición de Bienes',
  ),
  TaxRegime(key: '608', description: 'Demás ingresos'),
  TaxRegime(
    key: '610',
    description:
        'Residentes en el Extranjero sin Establecimiento Permanente en México',
  ),
  TaxRegime(
    key: '611',
    description: 'Ingresos por Dividendos (socios y accionistas)',
  ),
  TaxRegime(
    key: '612',
    description:
        'Personas Físicas con Actividades Empresariales y Profesionales',
  ),
  TaxRegime(key: '614', description: 'Ingresos por intereses'),
  TaxRegime(
    key: '615',
    description: 'Régimen de los ingresos por obtención de premios',
  ),
  TaxRegime(key: '616', description: 'Sin obligaciones fiscales'),
  TaxRegime(
    key: '620',
    description:
        'Sociedades Cooperativas de Producción que optan por diferir sus ingresos',
  ),
  TaxRegime(key: '621', description: 'Incorporación Fiscal'),
  TaxRegime(
    key: '622',
    description: 'Actividades Agrícolas, Ganaderas, Silvícolas y Pesqueras',
  ),
  TaxRegime(key: '623', description: 'Opcional para Grupos de Sociedades'),
  TaxRegime(key: '624', description: 'Coordinados'),
  TaxRegime(
    key: '625',
    description:
        'Régimen de las Actividades Empresariales con ingresos a través de Plataformas Tecnológicas',
  ),
  TaxRegime(key: '626', description: 'Régimen Simplificado de Confianza'),
];
