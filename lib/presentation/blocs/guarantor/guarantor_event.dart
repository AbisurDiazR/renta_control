import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/guarantor/guarantor.dart';

abstract class GuarantorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchGuarantors extends GuarantorEvent {}

class AddGuarantor extends GuarantorEvent {
  final Guarantor guarantor;

  AddGuarantor({required this.guarantor});

  @override
  List<Object> get props => [guarantor];
}

class UpdateGuarantor extends GuarantorEvent {
  final Guarantor guarantor;

  UpdateGuarantor({required this.guarantor});

  @override
  List<Object> get props => [guarantor];
}

class SearchGuarantors extends GuarantorEvent {
  final String query;

  SearchGuarantors({required this.query});

  @override
  List<Object?> get props => [query];
}

class GuarantorsUpdated extends GuarantorEvent {
  final List<Guarantor> guarantors;

  GuarantorsUpdated({required this.guarantors});

  @override
  List<Object> get props => [guarantors];
}

class DeleteGuarantor extends GuarantorEvent {
  final String guarantorId;

  DeleteGuarantor({required this.guarantorId});

  @override
  List<Object> get props => [guarantorId];
}
