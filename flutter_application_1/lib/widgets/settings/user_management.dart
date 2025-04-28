import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/admin_provider.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({Key? key, required User currentUser}) : super(key: key);

  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final TextEditingController _searchController = TextEditingController();
  String selectedRole = 'All';  String _sortBy = 'Name';

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        final users = adminProvider.users;
        final filteredUsers = _getFilteredUsers(users, selectedRole);
        
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Management',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              
              // Search and filter bar
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Search Users',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                    });
                                  },
                                )
                              : null,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Filter by Role',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              value: selectedRole,
                              items: [
                                'All',
                                'Admin',
                                'Customer',
                                'Driver',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedRole = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Sort by',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              value: _sortBy,
                              items: ['Name', 'Email', 'Role', 'Date Joined'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _sortBy = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // User list
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Users (${filteredUsers.length})',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _showAddUserDialog(context);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add User'),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      if (filteredUsers.isEmpty) ...[
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text(
                              'No users found matching your criteria',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ] else ...[
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredUsers.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getRoleColor(user.role.toString()),
                                child: Text(
                                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(user.name),
                              subtitle: Text(user.email),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Chip(
                                    label: Text(
                                      user.role.toString(),
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                    backgroundColor: _getRoleColor(user.role.toString()),
                                  ),
                                  PopupMenuButton(
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit User'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete User'),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _showEditUserDialog(context, user);
                                      } else if (value == 'delete') {
                                        _showDeleteUserDialog(context, user);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                _showUserDetailsDialog(context, user);
                              },
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // User Analytics
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Analytics',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildAnalyticsCard(
                              title: 'Total Users',
                              value: users.length.toString(),
                              icon: Icons.people,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildAnalyticsCard(
                              title: 'Admins',
                              value: users.where((u) => u.role.toString() == 'Admin').length.toString(),
                              icon: Icons.admin_panel_settings,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildAnalyticsCard(
                              title: 'Customers',
                              value: users.where((u) => u.role.toString() == 'Customer').length.toString(),
                              icon: Icons.person,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildAnalyticsCard(
                              title: 'Drivers',
                              value: users.where((u) => u.role.toString() == 'Driver').length.toString(),
                              icon: Icons.drive_eta,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            // View detailed analytics
                          },
                          icon: const Icon(Icons.analytics),
                          label: const Text('View Detailed Analytics'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Bulk Actions
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bulk Actions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Import users
                              },
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Import Users'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Export users
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('Export Users'),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _showBulkRoleUpdateDialog(context);
                              },
                              icon: const Icon(Icons.people),
                              label: const Text('Update Roles'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _showBulkDeleteDialog(context);
                              },
                              icon: const Icon(Icons.delete),
                              label: const Text('Delete Users'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }  
  List<User> _getFilteredUsers(List<User> users, String filterRole) {
    return users.where((user) {
      // Apply role filter
      if (filterRole != 'All' && user.role != filterRole) {
        return false;
      }
      
      // Apply search filter
      if (_searchController.text.isNotEmpty) {
        final searchTerm = _searchController.text.toLowerCase();
        return user.name.toLowerCase().contains(searchTerm) ||
               user.email.toLowerCase().contains(searchTerm);
      }
      
      return true;
    }).toList()
      ..sort((a, b) {
        // Apply sorting
        switch (_sortBy) {
          case 'Name':
            return a.name.compareTo(b.name);
          case 'Email':
            return a.email.compareTo(b.email);
          case 'Role':
            return a.role.toString().compareTo(b.role.toString());
          case 'Date Joined':
            return (a.dateJoined ?? DateTime(0)).compareTo(b.dateJoined ?? DateTime(0));
          default:
            return a.name.compareTo(b.name);
        }
      });
  }    Color _getRoleColor(String role) {    switch (role) {
      case 'Admin':
        return Colors.purple;
      case 'Customer':
        return Colors.green;
      case 'Driver':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  Widget _buildAnalyticsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showAddUserDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final phoneController = TextEditingController();

    UserRole selectedRole = UserRole.customer;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (context, setState) {

                  return DropdownButtonFormField<UserRole>(
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedRole,


                    items: UserRole.values.map((UserRole role) {
                      return DropdownMenuItem<UserRole>(
                        value: role,

                        child: Text(role.name),
                      );
                    }).toList(),
                    onChanged: (UserRole? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedRole = newValue;
                        });
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              // Validate and add user
              if (nameController.text.isNotEmpty && 
                  emailController.text.isNotEmpty &&
                  passwordController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
  
                final adminProvider = Provider.of<AdminProvider>(context, listen: false);
  
                adminProvider.addUser(User(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  email: emailController.text,
                  phoneNumber: phoneController.text,
                  role: selectedRole,
                  createdAt: DateTime.now(),
                  password: passwordController.text, // Changed hashedPassword to password
                ));
  
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all fields'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );


  }                void _showEditUserDialog(BuildContext context, User user) {                  final nameController = TextEditingController(text: user.name);                  final emailController = TextEditingController(text: user.email);                  UserRole selectedRole = user.role;
    
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Edit User'),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            StatefulBuilder(
                              builder: (context, setState) {
                                return DropdownButtonFormField<UserRole>(
                                  decoration: const InputDecoration(
                                    labelText: 'Role',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: selectedRole,
                                  items: UserRole.values.map((UserRole role) {
                                    return DropdownMenuItem<UserRole>(
                                      value: role,
                                      child: Text(role.toString().split('.').last),
                                    );
                                  }).toList(),
                                  onChanged: (UserRole? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        selectedRole = newValue;
                                      });
                                    }
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Validate and update user
                            if (nameController.text.isNotEmpty && 
                                emailController.text.isNotEmpty) {
                
                              final adminProvider = Provider.of<AdminProvider>(context, listen: false);
                
                              adminProvider.updateUser(User(
                                id: user.id,
                                name: nameController.text,
                                email: emailController.text,
                                phoneNumber: user.phoneNumber,
                                role: selectedRole,
                                dateJoined: user.dateJoined,
                                password: user.password,
                              ));
                
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('User updated successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all fields'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: const Text('UPDATE'),
                        ),
                      ],
                    ),
                  );
                }                  void _showDeleteUserDialog(BuildContext context, User user) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete User?'),
                      content: Text(
                        'Are you sure you want to delete "${user.name}"? This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            final adminProvider = Provider.of<AdminProvider>(context, listen: false);
                            adminProvider.deleteUser(user.id);
              
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('User deleted successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: const Text(
                            'DELETE',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                }
  
                void _showUserDetailsDialog(BuildContext context, User user) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(user.name),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.email),
                            title: const Text('Email'),
                            subtitle: Text(user.email),
                          ),
                          ListTile(
                            leading: Icon(
                              _getRoleIcon(user.role.toString()),
                              color: _getRoleColor(user.role.toString()),
                            ),
                            title: const Text('Role'),
                            subtitle: Text(user.role.toString()),
                          ),
                          ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('Date Joined'),
                            subtitle: Text(
                              '${user.dateJoined?.day}/${user.dateJoined?.month}/${user.dateJoined?.year}',
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('CLOSE'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showEditUserDialog(context, user);
                          },
                          child: const Text('EDIT'),
                        ),
                      ],
                    ),
                  );


                }                  IconData _getRoleIcon(String role) {                  switch (role) {                    case 'Admin':
                      return Icons.admin_panel_settings;
                    case 'Customer':
                      return Icons.person;
                    case 'Driver':
                      return Icons.drive_eta;
                    default:
                      return Icons.person_outline;
                  }
                }
  
                void _showBulkRoleUpdateDialog(BuildContext context) {
                  String selectedRole = 'Customer';
    
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Bulk Update Roles'),
                      content: StatefulBuilder(
                        builder: (context, setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'This will update the role for all users that match your current filter criteria.',
                              ),
                              const SizedBox(height: 16),
                
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'New Role',
                                  border: OutlineInputBorder(),
                                ),
                                value: selectedRole,
                                items: ['Admin', 'Customer', 'Driver'].map((String role) {
                                  return DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(role),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selectedRole = newValue;
                                    });
                                  }
                                },
                              ),
                
                              const SizedBox(height: 16),
                
                              Consumer<AdminProvider>(
                                builder: (context, adminProvider, child) {
                                  final filteredUsers = _getFilteredUsers(adminProvider.users, _searchController.text);
                                  return Text(
                                    'This will affect ${filteredUsers.length} users',
                                    style: const TextStyle(fontStyle: FontStyle.italic),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            final adminProvider = Provider.of<AdminProvider>(context, listen: false);
                            final filteredUsers = _getFilteredUsers(adminProvider.users, _searchController.text);
              
                            for (final user in filteredUsers) {
                              adminProvider.updateUser(User(
                                id: user.id,
                                name: user.name,
                                email: user.email,
                                role: UserRole.values.firstWhere((e) => e.toString().split('.').last == selectedRole),
                                dateJoined: user.dateJoined,
                                password: user.password,
                              ));
                            }
              
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Role updated to $selectedRole for ${filteredUsers.length} users'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: const Text('UPDATE'),
                        ),
                      ],
                    ),
                  );
                }  
                void _showBulkDeleteDialog(BuildContext context) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Bulk Delete Users'),
                      content: Consumer<AdminProvider>(
                        builder: (context, adminProvider, child) {
                          final filteredUsers = _getFilteredUsers(adminProvider.users, _searchController.text);
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Are you sure you want to delete all users that match your current filter criteria? This action cannot be undone.',
                                style: TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'This will delete ${filteredUsers.length} users',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            final adminProvider = Provider.of<AdminProvider>(context, listen: false);
                            final filteredUsers = _getFilteredUsers(adminProvider.users, _searchController.text);
              
                            for (final user in filteredUsers) {
                              adminProvider.deleteUser(user.id);
                            }
              
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${filteredUsers.length} users deleted successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: const Text(
                            'DELETE',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                }  
                @override
                void dispose() {
                  _searchController.dispose();
                  super.dispose();
                }
} 