import React, { createContext, useContext, useState, useEffect } from 'react'

const AuthContext = createContext()

export const AuthProvider = ({ children }) => {
  const [isLoggedIn, setIsLoggedIn] = useState(() => {
    return !!localStorage.getItem('admin_user')
  })
  const [user, setUser] = useState(null)
  const login = (user) => {
    console.log('user', user)
    localStorage.setItem('admin_user', JSON.stringify(user))
    setIsLoggedIn(true)
  }

  // Hàm logout: Xóa token khỏi localStorage
  const logout = () => {
    localStorage.removeItem('admin_user')
    window.location.href = '/login'
    setIsLoggedIn(false)
  }

  // Theo dõi sự thay đổi của trạng thái khi reload trang
  useEffect(() => {
    const user = localStorage.getItem('admin_user')
    if (user) {
      setIsLoggedIn(true)
    }
  }, [])

  return (
    <AuthContext.Provider value={{ isLoggedIn, login, logout, user }}>
      {children}
    </AuthContext.Provider>
  )
}

// Hook để sử dụng AuthContext
export const useAuth = () => useContext(AuthContext)