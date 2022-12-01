# Deploy
flow project deploy --update

# SQoS (optional)
## set sqos
### Optimistic
flow transactions send ./transactions/setOptimistic.cdc --signer emulator-Alice

### Hidden & Reveal
flow transactions send ./transactions/setHiddenReveal.cdc --signer emulator-Alice

## get sqos
flow scripts execute ./scripts/getSQoS.cdc 0x01cf0e2f2f715450