local M = {}

local REPO_URL = "https://github.com/ThatOneShortGuy/sf-formula-parser"
local REV_FILE = vim.fs.joinpath(vim.fn.stdpath("data"), "sf_formula_lsp_rev")
local INSTALL_ROOT = vim.fs.joinpath(vim.fn.stdpath("data"), "sf_formula_nvim")

local function installed_bin()
	local bin = vim.fs.joinpath(INSTALL_ROOT, "bin", "sf_formula_lsp")
	if vim.loop.os_uname().sysname == "Windows_NT" then
		return bin .. ".exe"
	end
	return bin
end

local function lsp_cmd()
	if vim.g.sf_formula_lsp_cmd and vim.g.sf_formula_lsp_cmd[1] then
		return vim.g.sf_formula_lsp_cmd[1]
	end

	if vim.fn.executable("sf_formula_lsp") == 1 then
		return "sf_formula_lsp"
	end

	local local_bin = installed_bin()
	if vim.fn.executable(local_bin) == 1 then
		return local_bin
	end

	return nil
end

local function read_rev()
	local f = io.open(REV_FILE, "r")
	if not f then
		return nil
	end

	local value = f:read("*l")
	f:close()
	if value == "" then
		return nil
	end

	return value
end

local function write_rev(rev)
	if not rev or rev == "" then
		return
	end

	local f = io.open(REV_FILE, "w")
	if not f then
		return
	end

	f:write(rev)
	f:close()
end

local function remote_head_rev()
	local result = vim.system({ "git", "ls-remote", REPO_URL, "HEAD" }, { text = true }):wait()
	if result.code ~= 0 then
		return nil
	end

	local rev = result.stdout:match("^(%x+)")
	if not rev or #rev ~= 40 then
		return nil
	end

	return rev
end

function M.ensure_lsp()
	local cmd = lsp_cmd()
	local remote_rev = remote_head_rev()
	local installed_rev = read_rev()

	if cmd and remote_rev and installed_rev == remote_rev then
		return
	end

	if cmd and not remote_rev then
		return
	end

	local install_cmd = {
		"cargo",
		"install",
		"--force",
		"--locked",
		"--root",
		INSTALL_ROOT,
		"--git",
		REPO_URL,
		"sf_formula_lsp",
	}

	if remote_rev then
		table.insert(install_cmd, 9, "--rev")
		table.insert(install_cmd, 10, remote_rev)
	end

	local result = vim.system(install_cmd, { text = true }):wait()
	if result.code ~= 0 then
		error(result.stderr ~= "" and result.stderr or result.stdout)
	end

	write_rev(remote_rev)
end

return M
