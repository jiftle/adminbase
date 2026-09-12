// Package logic 统一注册所有业务逻辑实现，通过空导入触发各组件的 init 注册。
package logic

import (
	_ "github.com/jiftle/adminbase/internal/logic/auth"
	_ "github.com/jiftle/adminbase/internal/logic/config"
	_ "github.com/jiftle/adminbase/internal/logic/dept"
	_ "github.com/jiftle/adminbase/internal/logic/dict"
	_ "github.com/jiftle/adminbase/internal/logic/log"
	_ "github.com/jiftle/adminbase/internal/logic/menu"
	_ "github.com/jiftle/adminbase/internal/logic/role"
	_ "github.com/jiftle/adminbase/internal/logic/user"
)
