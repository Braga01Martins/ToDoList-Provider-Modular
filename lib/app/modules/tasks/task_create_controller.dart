// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_todolist_provider/app/core/notifier/default_change_notifier.dart';
import '../../services/tasks/tasks_service.dart';

class TaskCreateController extends DefaultChangeNotifier {
  final TasksService _tasksService;
  DateTime? _selectedDate;

  TaskCreateController({
    required TasksService tasksService,
  }) : _tasksService = tasksService;

  set selectedDate(DateTime? selectedDate) {
    resetState();
    _selectedDate = selectedDate;
    notifyListeners();
  }

  DateTime? get selectedDate => _selectedDate;

  void save(String description) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      if (_selectedDate != null) {
        await _tasksService.save(_selectedDate!, description);
      } else {
        setError('Data da task não selecionada');
      }
    } catch (e, s) {
      print(e);
      print(s);
      setError('Erro ao cadastrar task');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
