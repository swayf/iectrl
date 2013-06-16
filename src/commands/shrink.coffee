cli = require '../cli'

module.exports = (program) -> program
  .command('shrink [names]')
  .description('shrink disk usage for virtual machines if archive is present')
  .action (names, command) ->
    cli.fail cli.find(names, 'ovaed', 'archived').found()
      .then (vms) ->
        # Pull out duplicate XP vms because they share an OVA.
        xps = (vm for vm in vms when vm.os is 'WinXP')
        rest = (vm for vm in vms when vm.os isnt 'WinXP')
        rest.push xps[0] if xps.length > 0
        cli.dsl(rest).all (vm) -> vm.unova()