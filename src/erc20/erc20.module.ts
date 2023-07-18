import { Module } from '@nestjs/common';
import { Erc20Service } from './erc20.service';
import { Erc20Controller } from './erc20.controller';

@Module({
  controllers: [Erc20Controller],
  providers: [Erc20Service],
})
export class Erc20Module {}
