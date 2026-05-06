import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/backend/authenticator.dart';
import '../../theme/app_spacing.dart';
import '../components/app_button.dart';
import '../components/app_input.dart';
import '../providers/user_provider.dart';

class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});
  static const routeName = '/account-settings';

  @override
  ConsumerState<AccountSettingsScreen> createState() =>
      _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isUploadingImage = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 512,
    );

    if (image == null) return;

    setState(() => _isUploadingImage = true);
    try {
      await const Authenticator().uploadProfilePicture(File(image.path));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await const Authenticator()
          .updateDisplayName(_nameController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Account Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: userAsync.when(
        data: (user) {
          if (_nameController.text.isEmpty && user != null) {
            _nameController.text = user.displayName;
          }
          if (_emailController.text.isEmpty && user != null) {
            _emailController.text = user.email;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.space6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatarSection(
                    context, user?.displayName ?? '', user?.photoURL),
                const SizedBox(height: AppSpacing.space8),
                AppInput(
                  label: 'DISPLAY NAME',
                  controller: _nameController,
                  hint: 'Enter your name',
                ),
                const SizedBox(height: AppSpacing.space4),
                AppInput(
                  label: 'EMAIL ADDRESS',
                  controller: _emailController,
                  readOnly: true,
                  hint: '',
                ),
                const SizedBox(height: AppSpacing.space12),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: 'Save Changes',
                    onPressed: _isLoading ? null : _saveChanges,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildAvatarSection(
      BuildContext context, String name, String? photoURL) {
    final theme = Theme.of(context);
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            backgroundImage: photoURL != null ? NetworkImage(photoURL) : null,
            child: photoURL == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: TextStyle(
                      fontSize: 40,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          if (_isUploadingImage)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: _isUploadingImage ? null : _pickAndUploadImage,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: theme.colorScheme.surface, width: 2),
                ),
                child:
                    const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
