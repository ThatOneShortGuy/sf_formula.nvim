local M = {}

local function installed_bin()
	local bin = vim.fs.joinpath(vim.fn.stdpath("data"), "sf_formula_nvim", "bin", "sf_formula_lsp")
	if vim.loop.os_uname().sysname == "Windows_NT" then
		return bin .. ".exe"
	end
	return bin
end

local function plugin_repo_root()
	local source = debug.getinfo(1, "S").source:sub(2)
	local this_dir = vim.fn.fnamemodify(source, ":p:h")
	-- this_dir = .../sf_formula.nvim/lua/sf_formula
	return vim.fs.normalize(vim.fs.joinpath(this_dir, "..", "..", ".."))
end

local function find_cmd()
	if vim.g.sf_formula_lsp_cmd then
		return vim.g.sf_formula_lsp_cmd
	end

	if vim.fn.executable("sf_formula_lsp") == 1 then
		return { "sf_formula_lsp" }
	end

	local local_bin = installed_bin()
	if vim.fn.executable(local_bin) == 1 then
		return { local_bin }
	end

	local repo_root = plugin_repo_root()
	local unix_bin = vim.fs.joinpath(repo_root, "target", "release", "sf_formula_lsp")
	local win_bin = unix_bin .. ".exe"

	if vim.fn.executable(unix_bin) == 1 then
		return { unix_bin }
	end

	if vim.fn.executable(win_bin) == 1 then
		return { win_bin }
	end

	return nil
end

function M.start_lsp_for_buffer(bufnr)
	local cmd = find_cmd()
	if not cmd then
		vim.notify("sf_formula_lsp not found. Run :Lazy sync, set vim.g.sf_formula_lsp_cmd, or put it on PATH.", vim.log.levels.ERROR)
		return
	end

	bufnr = bufnr or 0
	local root = vim.fs.root(bufnr, { ".git", "Cargo.toml" }) or vim.fn.getcwd()

	local client_id = vim.lsp.start({
		name = "sf-formula-lsp",
		cmd = cmd,
		root_dir = root,
		bufnr = bufnr,
	}, {
		reuse_client = function(client, config)
			return client.name == config.name and client.config.root_dir == config.root_dir
		end,
	})

	if not client_id then
		vim.notify("Failed to start sf_formula_lsp", vim.log.levels.ERROR)
	end
end

function M.start_lsp_for_current_buffer()
	M.start_lsp_for_buffer(0)
end

return M
