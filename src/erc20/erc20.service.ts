import { Injectable } from '@nestjs/common';
import { ERC20__factory } from 'types/ethers-contracts';
import { SignerService } from 'src/signer/signer.service';
import { Network } from 'src/web3/web3.service';

@Injectable()
export class Erc20Service {
  constructor(private readonly signerService: SignerService) {}

  async eq(
    amount: bigint,
    {
      account,
      contractAddress,
      network,
    }: {
      contractAddress: string;
      account: string;
      network: Network;
    },
  ): Promise<boolean> {
    const contract = ERC20__factory.connect(
      contractAddress,
      this.signerService.getSigner(network),
    );
    const balance = await contract.balanceOf(...[account]);

    return amount === balance;
  }

  async gte(
    amount: bigint,
    {
      account,
      contractAddress,
      network,
    }: {
      contractAddress: string;
      account: string;
      network: Network;
    },
  ): Promise<boolean> {
    const contract = ERC20__factory.connect(
      contractAddress,
      this.signerService.getSigner(network),
    );
    const balance = await contract.balanceOf(...[account]);

    return amount >= balance;
  }

  async lte(
    amount: bigint,
    {
      account,
      contractAddress,
      network,
    }: {
      contractAddress: string;
      account: string;
      network: Network;
    },
  ): Promise<boolean> {
    const contract = ERC20__factory.connect(
      contractAddress,
      this.signerService.getSigner(network),
    );
    const balance = await contract.balanceOf(...[account]);

    return amount <= balance;
  }
}
