import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/app_user.dart';

final currentUserProvider = Provider<AppUser>((ref) => AppUser.dummy);
