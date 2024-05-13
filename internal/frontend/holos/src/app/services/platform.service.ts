import { Inject, Injectable } from '@angular/core';
import { Observable, of, switchMap } from 'rxjs';
import { ObservableClient } from '../../connect/observable-client';
import { Organization } from '../gen/holos/organization/v1alpha1/organization_pb';
import { PlatformService as ConnectPlatformService } from '../gen/holos/platform/v1alpha1/platform_service_connect';
import { Platform, Spec } from '../gen/holos/platform/v1alpha1/platform_pb';
import { GetPlatformRequest, ListPlatformsRequest, UpdatePlatformOperation, UpdatePlatformRequest } from '../gen/holos/platform/v1alpha1/platform_service_pb';
import { FieldMask, JsonValue, Struct } from '@bufbuild/protobuf';

@Injectable({
  providedIn: 'root'
})
export class PlatformService {
  listPlatforms(org: Observable<Organization>): Observable<Platform[]> {
    return org.pipe(
      switchMap(org => {
        if (org.orgId == undefined) {
          return of([])
        }
        const req = new ListPlatformsRequest({ orgId: org.orgId })
        return this.client.listPlatforms(req).pipe(
          switchMap(resp => { return of(resp.platforms) })
        )
      })
    )
  }

  updateModel(platform: Platform, model: JsonValue): Observable<Platform | undefined> {
    const update = new UpdatePlatformOperation({ model: Struct.fromJson(model) })
    const updateMask = new FieldMask({ paths: ["update.model"] })
    const req = new UpdatePlatformRequest({ update: update, updateMask: updateMask })
    return this.client.updatePlatform(req).pipe(
      switchMap(resp => { return of(resp.platform) })
    )
  }

  getPlatform(platformId: string): Observable<Platform | undefined> {
    const req = new GetPlatformRequest({ platformId: platformId })
    return this.client.getPlatform(req).pipe(
      switchMap(resp => { return of(resp.platform) })
    )
  }

  constructor(@Inject(ConnectPlatformService) private client: ObservableClient<typeof ConnectPlatformService>) { }
}
