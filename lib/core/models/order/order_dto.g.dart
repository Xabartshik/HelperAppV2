// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderDtoImpl _$$OrderDtoImplFromJson(Map<String, dynamic> json) =>
    _$OrderDtoImpl(
      orderId: (json['orderId'] as num).toInt(),
      customerId: (json['customerId'] as num).toInt(),
      branchId: (json['branchId'] as num).toInt(),
      deliveryType: json['deliveryType'] as String,
      paymentType: json['paymentType'] as String,
      status: json['status'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      deliveryDate: json['deliveryDate'] == null
          ? null
          : DateTime.parse(json['deliveryDate'] as String),
      deliverySlotId: (json['deliverySlotId'] as num?)?.toInt(),
      destinationAddress: json['destinationAddress'] as String?,
      postamatId: (json['postamatId'] as num?)?.toInt(),
      postamatCellId: (json['postamatCellId'] as num?)?.toInt(),
      positions:
          (json['positions'] as List<dynamic>?)
              ?.map((e) => OrderPositionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$OrderDtoImplToJson(_$OrderDtoImpl instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'customerId': instance.customerId,
      'branchId': instance.branchId,
      'deliveryType': instance.deliveryType,
      'paymentType': instance.paymentType,
      'status': instance.status,
      'totalPrice': instance.totalPrice,
      'deliveryDate': instance.deliveryDate?.toIso8601String(),
      'deliverySlotId': instance.deliverySlotId,
      'destinationAddress': instance.destinationAddress,
      'postamatId': instance.postamatId,
      'postamatCellId': instance.postamatCellId,
      'positions': instance.positions,
    };

_$OrderPositionDtoImpl _$$OrderPositionDtoImplFromJson(
  Map<String, dynamic> json,
) => _$OrderPositionDtoImpl(
  uniqueId: (json['uniqueId'] as num).toInt(),
  itemId: (json['itemId'] as num).toInt(),
  itemName: json['itemName'] as String?,
  quantity: (json['quantity'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
);

Map<String, dynamic> _$$OrderPositionDtoImplToJson(
  _$OrderPositionDtoImpl instance,
) => <String, dynamic>{
  'uniqueId': instance.uniqueId,
  'itemId': instance.itemId,
  'itemName': instance.itemName,
  'quantity': instance.quantity,
  'price': instance.price,
};
