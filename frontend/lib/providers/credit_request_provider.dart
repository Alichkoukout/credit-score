import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/credit_request.dart';
import 'auth_provider.dart';

class CreditRequestProvider with ChangeNotifier {
  final AuthProvider authProvider;
  List<CreditRequest> _requests = [];
  bool _isLoading = false;

  List<CreditRequest> get requests => _requests;
  bool get isLoading => _isLoading;

  CreditRequestProvider(this.authProvider);

  Future<void> fetchUserRequests() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.userRequests),
        headers: authProvider.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _requests = data.map((json) => CreditRequest.fromJson(json)).toList();
      }
    } catch (e) {
      // Gérer l'erreur
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPendingRequests() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.agentPendingRequests),
        headers: authProvider.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _requests = data.map((json) => CreditRequest.fromJson(json)).toList();
      }
    } catch (e) {
      // Gérer l'erreur
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllRequests() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.agentRequests),
        headers: authProvider.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _requests = data.map((json) => CreditRequest.fromJson(json)).toList();
      }
    } catch (e) {
      // Gérer l'erreur
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createRequest(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.createRequest),
        headers: authProvider.getAuthHeaders(),
        body: jsonEncode(data),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> validateRequest(int requestId, double finalScore, String justification, String actionType) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.validateRequest}/$requestId/validate'),
        headers: authProvider.getAuthHeaders(),
        body: jsonEncode({
          'finalScore': finalScore,
          'justification': justification,
          'actionType': actionType,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

