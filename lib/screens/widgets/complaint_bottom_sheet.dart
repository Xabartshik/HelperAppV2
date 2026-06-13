import 'package:flutter/material.dart';
import 'package:helper_app/core/models/order/order_dto.dart';
import 'package:helper_app/core/models/order/complaint_dto.dart'; 

class ComplaintBottomSheet extends StatefulWidget {
  final OrderDto order;

  const ComplaintBottomSheet({super.key, required this.order});

  @override
  State<ComplaintBottomSheet> createState() => _ComplaintBottomSheetState();
}

class _ComplaintBottomSheetState extends State<ComplaintBottomSheet> {
  String? _selectedReason;
  final TextEditingController _commentController = TextEditingController();
  
  // Храним ID выбранных товаров
// Было: final Set<int> _selectedItemIds = {};
  final Map<int, int> _problemItems = {}; // Измененная строка
  
  // Имитация прикрепленных фото (пока просто счетчик)
  int _photoCount = 0;

  // Общие причины для всех типов доставки
  final List<String> _reasons = [
    'Брак / Повреждение товара',
    'Недовоз (не хватает товаров)',
    'Перепутан товар',
    'Повреждена упаковка заказа',
    'Другое'
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComplaint() {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, выберите причину жалобы'))
      );
      return;
    }

    // Здесь формируется DTO. В будущем ты передашь его в ApiClient
    final complaint = ComplaintDto(
      orderId: widget.order.orderId,
      reason: _selectedReason!,
      comment: _commentController.text.isNotEmpty ? _commentController.text : null,
      problemItemIds: _problemItems,
      photoPaths: List.generate(_photoCount, (index) => 'dummy_path_$index.jpg'), // Заглушка
    );

    // TODO: Вызвать метод ApiClient для отправки complaint
    print('Отправка жалобы: $complaint');

    Navigator.pop(context); // Закрываем BottomSheet
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Жалоба успешно отправлена. Мы скоро с вами свяжемся.'),
        backgroundColor: Colors.green,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // Получаем высоту экрана, чтобы ограничить высоту BottomSheet
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.85, // Занимает 85% экрана
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Шапка с крестиком
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 24, right: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Что пошло не так?',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const Text('Выберите причину:', style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 12),
                
                // Выбор причины (Радио-кнопки)
                ..._reasons.map((reason) => _buildReasonRadio(reason)),
                
                const SizedBox(height: 24),
                
                // Выбор проблемных товаров
                if (widget.order.positions.isNotEmpty) ...[
                  const Text('С какими товарами проблема?', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('Выберите один или несколько товаров (необязательно)', style: TextStyle(color: Colors.white38, fontSize: 13)),
                  const SizedBox(height: 12),
                  
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: widget.order.positions.map((pos) => _buildItemCounter(pos)).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Поле комментария
                const Text('Комментарий', style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 12),
                TextField(
                  controller: _commentController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Опишите проблему подробнее...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF2C2C2E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),

                // Заглушка для фото
                const Text('Фотографии', style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (_photoCount < 3) {
                          setState(() => _photoCount++);
                        }
                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.5), width: 1, style: BorderStyle.solid),
                        ),
                        child: const Icon(Icons.add_a_photo, color: Color(0xFF7C3AED)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        _photoCount == 0 
                            ? 'Прикрепите фото дефекта (до 3 шт.)' 
                            : 'Добавлено фото: $_photoCount / 3',
                        style: const TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                
                // Добавляем отступ снизу, чтобы клавиатура не перекрывала
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 40),
              ],
            ),
          ),

          // Кнопка отправки зафиксирована внизу
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitComplaint,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Отправить', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonRadio(String reason) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.white38,
      ),
      child: RadioListTile<String>(
        title: Text(reason, style: const TextStyle(color: Colors.white)),
        value: reason,
        groupValue: _selectedReason,
        activeColor: const Color(0xFF7C3AED),
        contentPadding: EdgeInsets.zero,
        onChanged: (value) {
          setState(() {
            _selectedReason = value;
          });
        },
      ),
    );
  }

Widget _buildItemCounter(OrderPositionDto pos) {
    final currentCount = _problemItems[pos.itemId] ?? 0;
    final maxCount = pos.quantity;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pos.itemName ?? 'Неизвестный товар', style: const TextStyle(color: Colors.white, fontSize: 14)),
                Text('В заказе: $maxCount шт.', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                onPressed: currentCount > 0 ? () {
                  setState(() {
                    if (currentCount == 1) {
                      _problemItems.remove(pos.itemId);
                    } else {
                      _problemItems[pos.itemId] = currentCount - 1;
                    }
                  });
                } : null,
              ),
              SizedBox(
                width: 30,
                child: Text('$currentCount', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                onPressed: currentCount < maxCount ? () {
                  setState(() => _problemItems[pos.itemId] = currentCount + 1);
                } : null,
              ),
            ],
          )
        ],
      ),
    );
  }


}